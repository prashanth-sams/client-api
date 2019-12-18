# require 'byebug'
# describe 'Named parameter', :focus do
#
#   it "Named parameter - GET" do
#     api = ClientApi::Api.new
#
#     api.get("/api/users?page=2")
#     expect(api.status).to eq(200)
#
#     api.get(
#         :url => "/api/users?",
#         :query => {
#             "page": 2
#         }
#     )
#     expect(api.status).to eq(200)
#
#     api.get(
#         :url => "/api/users?",
#         :query => {
#             "page": "2"
#         }
#     )
#     expect(api.status).to eq(200)
#
#     api.get(
#         :url => "/api/users?",
#         :query => {
#         }
#     )
#     expect(api.status).to eq(200)
#
#     api.get(
#         :url => "/api/users?",
#         :query => {
#             "page": 2
#         },
#         :headers =>  {
#             'Accept' => 'application/json'
#         }
#     )
#
#     api.get(
#         :url => "/api/users?",
#         :headers =>  {
#             'Accept' => 'application/json'
#         },
#         :query => {
#             "page": 2
#         }
#     )
#     expect(api.status).to eq(200)
#
#     api.get(
#         :query => {
#             "page": 2
#         },
#         :headers =>  {
#             'Accept' => 'application/json'
#         },
#         :url => "/api/users?",
#     )
#     expect(api.status).to eq(200)
#
#     api.get(
#         :url => "/api/users?",
#         :query => {
#             "page": 2,
#             "per_page": "3"
#         },
#         :headers =>  {
#             'Accept' => 'application/json'
#         }
#     )
#     expect(api.status).to eq(200)
#   end
#
#   # it "Named parameter - POST" do
#   #   api = ClientApi::Api.new
#   #
#   #   api.post("/api/users?page=2", {})
#   #
#   #   expect(api.status).to eq(200)
#   #   api.post(
#   #       :url => "/api/users?",
#   #       :body => {}
#   #   )
#   #   expect(api.status).to eq(200)
#   # end
#
#
# end
