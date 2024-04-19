class Api::V1::TagsController < ApplicationController
  before_action :must_sign_in
  before_action :set_tag, only: [:show, :update, :destroy]
  before_action :authorize_resource_access, only: [:show, :update, :destroy]

  def index
    tags = Tag.where(user_id: current_user.id)
    tags = tags.where(kind: params[:kind]) unless params[:kind].nil?
    paged = tags.page(params[:page])
    render_resources(paged, pager: {
      page: params[:page] || 1,
      per_page: Tag.default_per_page,
      count: tags.count
    })
  end
  
  def show
    render_resource(@tag)
  end
 
  def create
    render_resource Tag.create create_params.merge user: current_user
  end

  def update
    @tag.update(create_params)
    render_resource @tag
  end
  
  def destroy
    @tag.deleted_at = Time.now
    ActiveRecord::Base.transaction do
      begin
        if params[:with_items] == 'true'
          Item.where('tag_ids && ARRAY[?]::bigint[]', [@tag.id]).update!(deleted_at: Time.now)
        end
        @tag.save!
      rescue
        return head 422
      end
    end
    head :ok
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def create_params
    params.permit(:name, :sign, :kind)
  end
end
