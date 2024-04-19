class Api::V1::TagsController < ApplicationController
  def index
    return render status: 401 if current_user.nil?
    tags = Tag.where(user_id: current_user.id)
    tags = tags.where(kind: params[:kind]) unless params[:kind].nil?
    paged = tags.page(params[:page])
    render json: {resources: paged, pager: {
      page: params[:page] || 1,
      per_page: Tag.default_per_page,
      count: tags.count
    }}
  end
  def show
    tag = Tag.find params[:id]
    return head :forbidden unless tag.user_id == current_user.id
    render json: {resource: tag}
  end
  def create
    return render status: 401 if current_user.nil?

    tag = Tag.new params.permit(:name, :sign, :kind)
    tag.user = current_user
    if tag.save
      render json: {resource: tag}, status: :ok
    else
      render json: {errors: tag.errors}, status: :unprocessable_entity
    end
  end
  def update
    tag = Tag.find params[:id]
    tag.update params.permit(:name, :sign)
    if tag.errors.empty?
      render json: {resource: tag}
    else
      render json: {errors: tag.errors}, status: :unprocessable_entity
    end
  end
  def destroy
    tag = Tag.find params[:id]
    return head :forbidden unless tag.user_id == current_user.id
    tag.deleted_at = Time.now
    ActiveRecord::Base.transaction do
      begin
        if params[:with_items] == 'true'
          Item.where('tag_ids && ARRAY[?]::bigint[]', [tag.id])
              .update!(deleted_at: Time.now)
        end
        tag.save!
      rescue
        return head 422
      end
      head :ok
    end
  end
end
