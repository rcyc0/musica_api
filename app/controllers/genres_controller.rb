# frozen_string_literal: true

class GenresController < ApplicationController
  before_action :set_genre, only: [:show, :update, :destroy]

  # GET /genres
  # GET /genres.json
  def index
    @genres = Genre.all
  end

  # GET /genres/1
  # GET /genres/1.json
  def show
  end

  # POST /genres
  # POST /genres.json
  def create
    @genre = Genre.new(genre_params)

    if @genre.save
      render :show, status: :created, location: @genre
    else
      render json: @genre.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /genres/1
  # PATCH/PUT /genres/1.json
  def update
    if @genre.update(genre_params)
      render :show, status: :ok, location: @genre
    else
      render json: @genre.errors, status: :unprocessable_entity
    end
  end

  # DELETE /genres/1
  # DELETE /genres/1.json
  def destroy
    @genre.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_genre
    @genre = Genre.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def genre_params
    params.require(:genre).permit(:name, :genre_number)
  end
end
