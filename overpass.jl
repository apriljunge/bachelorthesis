using HTTP, Memoize, JSON






@memoize function get_json_from_overpass!(overpass_ql::String)
    json = JSON.parse(String(get_from_overpass!(overpass_ql).body))
    return json["elements"]
end

@memoize function get_from_overpass!(overpass_ql::String)
    endpoints = [
		"https://overpass-api.de/api/interpreter",
		"https://maps.mail.ru/osm/tools/overpass/api/interpreter"
	]
	for endpoint in endpoints
        try
            return HTTP.request("GET", endpoint, body=overpass_ql)
        catch
            @info "Timeout occurred while trying endpoint: $endpoint";
        end
    end
    @error "All endpoints failed."
    return nothing
end