# frozen_string_literal: true

class FeaturesController < ApplicationController
  ActionController::Parameters.action_on_unpermitted_parameters = false

  def index
    @current_page = pagination_params[:page] || 1
    @total = Feature.page(@current_page).total_pages
    @per_page = Feature.page(@current_page).limit_value

    @features = Feature.page(@current_page)
  end

  def refresh
    Features::EntryPoint.call

    @current_page = pagination_params[:page] || 1
    @total = Feature.page(@current_page).total_pages
    @per_page = Feature.page(@current_page).limit_value

    @features = Feature.page(@current_page)
  end

  def show
    @feature = Feature.find(params[:id])
  end

  def create_comment
    feature = Feature.new(feature_params)

    if feature.save
      render json: feature, status: :ok
    else
      render json: { error: 'Error creating Feature' }, status: :not_found
    end
  end

  def comments
    comments = Comment.where(feature_id: params[:id])

    render json: comments
  end

  def feature_params
    params.permit(:title, :description, :price, :feature_type_id, :user_id)
  end

  def pagination_params
    params.permit(:page)
  end
end
