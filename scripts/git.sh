alias g='git'
alias gb='git branch'
alias gc='git checkout'
alias gcb='git checkout -b'
alias gcl='git clone $(pbpaste)'
alias gst='git status'
alias gs='git stash'
alias ggl='git pull origin $(git_current_branch)'
alias ggp='git push origin $(git_current_branch)'
alias gm='git merge'
alias gf='git fetch'
alias glg='git log --graph --stat --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"'

alias gcd='git_checkout_delete'
function git_checkout_delete() {
    current=$(git_current_branch)
    target=${1-$(git config --get branch.working || git_main_branch)}

    git checkout $target
    git pull origin $target
    git branch -D $current
}

function git_current_branch() {
    local ref
    ref=$(git symbolic-ref --quiet HEAD 2>/dev/null)
    local ret=$?
    if [[ $ret != 0 ]]; then
        [[ $ret == 128 ]] && return
        ref=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || return
    fi
    echo ${ref#refs/heads/}
}

function git_main_branch() {
    command git rev-parse --git-dir &>/dev/null || return
    local ref
    for ref in refs/{heads,remotes/{origin,upstream}}/{main,master,develop}; do
        if command git show-ref -q --verify $ref; then
            echo ${ref:t}
            return 0
        fi
    done
    echo main
    return 1
}

function git_commit_amend() {
    # parse options using for loop to get new date, message if provided
    local new_date message
    while [[ $# -gt 0 ]]; do
        case $1 in
        -d|--date)
            if [[ -z "$2" ]]; then
                echo "Error: --date requires a value" >&2
                return 1
            fi
            new_date="$2"
            shift 2
            ;;
        -m|--message)
            if [[ -z "$2" ]]; then
                echo "Error: --message requires a value" >&2
                return 1
            fi
            message="$2"
            shift 2
            ;;
        *)
            echo "Usage: git_commit_amend [-d|--date <new_date>] [-m|--message <new_message>]" >&2
            return 1
            ;;
        esac
    done

    yellow='\033[1;33m'
    green='\033[1;32m'
    reset='\033[0m'
    if [[ -n "$new_date" && -n "$message" ]]; then
        old_date=$(git log -1 --format="%cd")
        old_message=$(git log -1 --format="%s")
        GIT_COMMITTER_DATE="$new_date" git commit --amend -m "$message" --date "$new_date"
        echo "Updated from ${yellow}${old_date}${reset} to $green${new_date}$reset"
        echo "Updated from ${yellow}${old_message}${reset} to $green${message}$reset"
        return 0
    fi
    if [[ -n "$message" ]]; then
        old_message=$(git log -1 --format="%s")
        git commit --amend --no-edit -m "$message"
        echo "Updated from ${yellow}${old_message}${reset} to $green${message}$reset"
        return 0
    fi
    if [[ -n "$new_date" ]]; then
        old_date=$(git log -1 --format="%cd")
        GIT_COMMITTER_DATE="$new_date" git commit --amend --no-edit --date "$new_date"
        echo "Updated from ${yellow}${old_date}${reset} to $green${new_date}$reset"
        return 0
    fi
}

### Check if fzf is installed
if (! command -v fzf &>/dev/null); then
    return 0
fi

function git_select_branch() {
    local mode=${1:-local}
    local branches selected_branch

    case $mode in
    local)
        local branch_list=()
        while IFS= read -r branch; do
            branch=$(sed 's/^[* ]*//' <<<$branch) # Remove leading '* ' or '  '
            if git rev-parse --verify "origin/$branch" >/dev/null 2>&1; then
                local behind=$(git rev-list --count "$branch..origin/$branch" 2>/dev/null || echo "0")
                if [[ "$behind" == "0" ]]; then
                    branch_list+=("$branch (up to date)")
                else
                    branch_list+=("$branch (${behind} commits behind)")
                fi
            else
                branch_list+=("$branch (no remote)")
            fi
        done < <(git branch)

        branches=$(printf '%s\n' "${branch_list[@]}")
        ;;
    remote)
        branches=$(git branch -r | grep -v "HEAD" | sed 's/^[* ] //; s/remotes\///')
        ;;
    all)
        branches=$(git branch -a | grep -v "HEAD" | sed 's/^[* ] //; s/remotes\///')
        ;;
    *)
        echo "Usage: git_select_branch [local|remote|all]" >&2
        return 1
        ;;
    esac

    [[ -z "$branches" ]] && {
        echo "No branches found." >&2
        return 1
    }

    selected_branch=$(echo "$branches" | fzf --height=20% --reverse --cycle --border --prompt="Select branch: " | awk '{print $1}')

    if [[ -n "$selected_branch" ]]; then
        echo "$selected_branch"
    else
        echo "No branch selected." >&2
        return 1
    fi
}

alias gbc='git_select_branch_copy'
function git_select_branch_copy() {
    local mode=${1:-local}
    local branch
    branch=$(git_select_branch "$mode") || return 1
    echo -n "$branch" | tr -d '\n' | pbcopy
    echo "Branch '$branch' copied to clipboard."
}

alias gC='git_select_checkout'
alias gCr='git_select_checkout remote'
function git_select_checkout() {
    mode=${1:-local}
    local branch
    branch=$(git_select_branch "$mode") || return 1
    git checkout "${branch/origin\//}"
}

alias gff='git_fast_forward_branch'
function git_fast_forward_branch() {
    local branch remote_branch
    branch="$(git_select_branch local)" || return 1
    remote_branch="origin/$branch"

    # Check if remote branch exists
    if ! git rev-parse --verify "$remote_branch" >/dev/null 2>&1; then
        echo "✗ Remote branch '$remote_branch' does not exist"
        return 1
    fi

    # Fast-forward the local branch to match remote
    git branch -f "$branch" "$remote_branch" 2> /dev/null \
        || git pull origin "$branch"
}
