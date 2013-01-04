class CommentsController < InheritedResources::Base
  belongs_to :post

  respond_to :json
end
