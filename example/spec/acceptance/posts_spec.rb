require 'spec_helper'
require 'rspec_api_documentation/dsl'

group "Posts" do
  header "Accept", "application/json"

  let(:post) { Post.create(:name => "Old Name", :title => "Old title", :content => "Old content") }

  get "/posts" do
    parameter :page, "Current page of posts"

    let(:page) { 1 }

    before do
      2.times do |i|
        Post.create(:name => "Post #{i}", :title => "Title #{i}", :content => "Content #{i}")
      end
    end

    example_request "Getting a list of posts" do
      response_body.should == Post.all.to_json
      status.should == 200
    end
  end

  post "/posts" do
    parameter :name, "Name of post"
    parameter :title, "Title of Post"
    parameter :content, "Content of Post"

    required_parameters :name, :title

    let(:name) { "Post 1" }
    let(:title) { "Title 1" }
    let(:content) { "Content 1" }

    scope_parameters :post, :all

    example_request "Creating an post" do
      explanation "Create an post"

      response_body.should be_json_eql({
        "name" => name,
        "title" => title,
        "content" => content,
      }.to_json)
      status.should == 201
    end
  end

  get "/posts/:id" do
    let(:id) { post.id }

    example_request "Getting a specific post" do
      response_body.should == post.to_json
      status.should == 200
    end
  end

  put "/posts/:id" do
    parameter :name, "Name of post"
    parameter :title, "Title of post"
    parameter :content, "Content of post"
    scope_parameters :post, :all

    let(:id) { post.id }
    let(:name) { "Updated Name" }
    let(:title) { "Updated Title" }

    example_request "Updating an post" do
      status.should == 204
    end
  end

  delete "/posts/:id" do
    let(:id) { post.id }

    example_request "Deleting an post" do
      status.should == 204
    end
  end

  put "/posts/:id/scope_request" do
    parameter :name, "Name of post"
    parameter :title, "Title of Post"
    parameter :content, "Content of post"

    scope_parameters :post, :all

    let(:id) { post.id }
    let(:name) { "NewName" }
    let(:title) { "NewTitle" }

    example_request "Scope Request demo" do
      status.should == 204
    end
  end

end
