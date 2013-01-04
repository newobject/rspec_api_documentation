class PostsController < InheritedResources::Base
  respond_to :json

  def scope_request
    @post = Post.find params[:id]
    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.json { head :no_content }
      else
        format.json { render :json => @post.errors, :status => :unprocessable_entity }
      end
    end
  end
end
