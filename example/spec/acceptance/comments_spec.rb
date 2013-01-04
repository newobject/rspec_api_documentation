require 'spec_helper'
require 'rspec_api_documentation/dsl'

group "Posts" do
  group "Comments" do
    header "Accept", "application/json"
    header "Content-Type", "application/json"

    let!(:post) { Post.create(:name => "Post 1", :title => "Title 1", :content => "Content 1") }

    get "/posts/:post_id/comments" do
      parameter :page, "Current page of comments"

      let(:page) { 1 }
      let(:post_id) { post.id }

      before do
        2.times do |i|
          post.comments.create(:commenter => "commenter #{i}", :body => "Body #{i}")
        end
      end

      example_request "Getting the list of comments of a post" do
        response_body.should == post.comments.reload.to_json
        status.should == 200
      end
    end
  end
end
