# frozen_string_literal: true

class FeaturesController < ApplicationController
  ActionController::Parameters.action_on_unpermitted_parameters = false

  # GET /feature
  def index
    @current_page = pagination_params[:page] || 1
    @per_page = pagination_params[:per_page] || 25

    prepare_features
  end

  # GET /feature/refresh
  def refresh
    RefreshEarthquakeFeaturesJob.perform_async

    render nothing: true, status: :ok

  end

  def prepare_features
    mag_type = feature_params[:mag_type]

    if mag_type.present?
      @total = Feature.where(mag_type:).page(@current_page).per(@per_page).total_pages
      @current_page = @total if @current_page.to_i > @total
      @features = Feature.where(mag_type:).order(:time).page(@current_page).per(@per_page)
    else
      @total = Feature.page(@current_page).per(@per_page).total_pages
      @features = Feature.order(:time).page(@current_page).per(@per_page)
    end
  end

  # GET /feature/:id
  def show
    @feature = Feature.find(feature_params[:id])
  end

  # POST /feature/:id/comments
  def create_comment
    @feature = Feature.find(feature_params[:id])

    comment = @feature.comments.new(comment_params)

    if comment.save
      render json: comment, status: :ok
    else
      render json: { error: 'Error creating comment' }, status: :not_found
    end
  end

  # GET /feature/:id/comments
  def comments
    comments = Comment.where(feature_id: feature_params[:id])

    render json: comments
  end

  def feature_params
    params.permit(:id, :mag_type)
  end

  def comment_params
    params.permit(:body)
  end

  def pagination_params
    params.permit(:page, :per_page)
  end
end
