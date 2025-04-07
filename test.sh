#!/bin/sh

agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/121.0"
allanime_refr="https://allmanga.to"
allanime_base="allanime.day"
allanime_api="https://api.${allanime_base}"
mode="sub"

search_anime() {
    search_gql="
        query(
            \$search: SearchInput
            \$limit: Int
            \$page: Int
            \$translationType: VaildTranslationTypeEnumType
            \$countryOrigin: VaildCountryOriginEnumType) {
                shows(
                    search: \$search
                    limit: \$limit
                    page: \$page
                    translationType: \$translationType
                    countryOrigin: \$countryOrigin) {
                        edges {
                            _id
                            name
                            availableEpisodes
                            __typename
                        }
                }
        }"

    curl -e "$allanime_refr" -s -G "${allanime_api}/api" -A "$agent" \
        --data-urlencode "variables={
            \"search\":{
                \"allowAdult\":false,
                \"allowUnknown\":false,
                \"query\":\"$1\"
            },
            \"limit\":40,
            \"page\":1,
            \"translationType\":\"$mode\",
            \"countryOrigin\":\"ALL\"
        }" \
        --data-urlencode "query=$search_gql"
#     | sed 's|Show|\
# | g' | sed -nE "s|.*_id\":\"([^\"]*)\",\"name\":\"(.+)\",.*${mode}\":([1-9][^,]*).*|\1	\2 (\3 episodes)|p" | sed 's/\\"//g'
}

search_anime ""
