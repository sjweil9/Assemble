class CommentsController < ApplicationController
    def create
        return redirect_to :back if Event.find(params[:event_id]) == nil
        comment = Comment.new(content: params[:content], user_id: session[:user_id], event_id: params[:event_id])
        flash[:content] = comment.errors[:content] unless comment.save
        return redirect_to :back 
    end

    def destroy
        comment = Comment.find(params[:id])
        comment.destroy if comment.user_id == session[:user_id]
        return redirect_to :back
    end
end
