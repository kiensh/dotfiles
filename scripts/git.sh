alias gb='git branch'
alias gc='git checkout'
alias gcb='git checkout -b'
alias gcl='git clone'
alias gst='git status'
alias gs='git stash'
alias ggl='git pull origin $(git_current_branch)'
alias ggp='git push origin $(git_current_branch)'
alias gm='git merge'
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

### Check if fzf is installed
if (! command -v fzf &>/dev/null); then
    return 0
fi

alias gb='git_select_branch'
alias gbr='git_select_branch remote'
function git_select_branch() {
    local mode=${1:-local}
    local branches selected_branch
    
    case $mode in
        local)
            local branch_list=()
            while IFS= read -r branch; do
                branch=$(sed 's/^[* ]*//' <<< $branch)  # Remove leading '* ' or '  '
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
    
    [[ -z "$branches" ]] && { echo "No branches found." >&2; return 1; }

    selected_branch=$(echo "$branches" | fzf --height=20% --reverse --cycle --border --prompt="Select branch: " | awk '{print $1}')
    
    if [[ -n "$selected_branch" ]]; then
        echo "$selected_branch" | tr -d '\n' | pbcopy
        echo "$selected_branch"
    else
        echo "No branch selected." >&2
        return 1
    fi
}

alias gc='git_select_checkout'
alias gcr='git_select_checkout remote'
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
    git branch -f "$branch" "$remote_branch"
}

