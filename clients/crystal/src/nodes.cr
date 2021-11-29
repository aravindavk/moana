module MoanaClient
  class Node
    def initialize(@client : Client, @cluster_name : String, @name : String)
    end

    def self.join(client : Client, cluster_name : String, name : String, endpoint : String)
      url = "#{client.url}/api/v1/clusters/#{cluster_name}/nodes"

      req = MoanaTypes::NodeRequest.new
      req.name = name
      req.endpoint = endpoint

      response = MoanaClient.http_post(
        url,
        req.to_json,
        headers: client.auth_header
      )
      if response.status_code == 201
        MoanaTypes::Node.from_json(response.body)
      else
        MoanaClient.error_response(response)
      end
    end

    def self.list(client : Client, cluster_name : String, state = false)
      url = "#{client.url}/api/v1/clusters/#{cluster_name}/nodes?state=#{state ? 1 : 0}"
      response = MoanaClient.http_get(
        url,
        headers: client.auth_header
      )
      if response.status_code == 200
        Array(MoanaTypes::Node).from_json(response.body)
      else
        MoanaClient.error_response(response)
      end
    end
  end
end