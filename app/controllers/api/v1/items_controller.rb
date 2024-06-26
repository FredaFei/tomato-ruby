class Api::V1::ItemsController < ApplicationController
  before_action :must_sign_in
  before_action :set_item, only: [:show, :update, :destroy]
  before_action :authorize_resource_access, only: [:show, :update, :destroy]

  def index
    items = Item.where(user_id: current_user.id)
      .where(happened_at: start_time..end_time)
    items = items.where(kind: params[:kind]) unless params[:kind].blank?
    paged = items.page(params[:page])
    render_resources(paged, pager: {
      page: params[:page] || 1,
      per_page: Item.default_per_page,
      count: items.count,
    })
  end

  def create
    render_resource Item.create create_params.merge user: current_user
  end

  def show
    render_resource(@item)
  end

  def update
    @item.update(create_params)
    render_resource @item
  end

  def destroy
    @item.deleted_at = Time.now
    if @item.save
      return head :ok
    else
      render_resource(@item)
    end
  end
  
  def balance
    current_user_id = current_user.id
    items = Item.where({ user_id: current_user_id })
      .where(happened_at: start_time..end_time)
    income_items = []
    expenses_items = []
    items.each { |item|
      if item.kind === "income"
        income_items << item
      else
        expenses_items << item
      end
    }
    income = income_items.sum(&:amount)
    expenses = expenses_items.sum(&:amount)
    render json: { income: income, expenses: expenses, balance: income - expenses }
  end

  def summary
    hash = Hash.new
    items = Item
      .where(user_id: current_user.id)
      .where(kind: params[:kind])
      .where(happened_at: start_time..end_time)
    tags = []
    items.each do |item|
      tags += item.tags
      if params[:group_by] == "happen_at" or params[:group_by] == "happened_at"
        key = item.happened_at.in_time_zone("Beijing").strftime("%F")
        hash[key] ||= 0
        hash[key] += item.amount
      else
        item.tag_ids.each do |tag_id|
          key = tag_id
          hash[key] ||= 0
          hash[key] += item.amount
        end
      end
    end
    groups = hash
      .map { |key, value|
      {
        "#{params[:group_by]}": key,
        tag: tags.find { |tag| tag.id == key },
        amount: value,
      }
    }
    if params[:group_by] == "happen_at" or params[:group_by] == "happened_at"
      groups.sort! { |a, b| a[:happened_at] <=> b[:happened_at] }
    elsif params[:group_by] == "tag_id"
      groups.sort! { |a, b| b[:amount] <=> a[:amount] }
    end
    render json: {
      groups: groups,
      total: items.sum(:amount),
    }
  end

  private

  def start_time
    # 如果 params[:happen_after] 存在就用它，否则就用 params[:happened_after]
    datetime_with_zone(params[:happen_after].presence || params[:happened_after])
  end

  def end_time
    datetime_with_zone(params[:happen_before].presence || params[:happened_before])
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def create_params
    params.permit(:amount, :happen_at, :happened_at, :kind, :note, tag_ids: [])
  end
end
