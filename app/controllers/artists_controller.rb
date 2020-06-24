# frozen_string_literal: true

class ArtistsController < ApplicationController
  before_action :set_artist, only: [:show, :update, :destroy]

  # GET /artists
  # GET /artists.json
  def index
    @artists = Artist.with_attached_picture.eager_load(:music).where('musics.user_id', current_user.id)
  end

  # GET /artists/1
  # GET /artists/1.json
  def show
  end

  # POST /artists
  # POST /artists.json
  def create
    @artist = Artist.new(artist_params)

    if @artist.save
      render :show, status: :created, location: @artist
    else
      render json: @artist.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /artists/1
  # PATCH/PUT /artists/1.json
  def update
    if @artist.update(artist_params)
      render :show, status: :ok, location: @artist
    else
      render json: @artist.errors, status: :unprocessable_entity
    end
  end

  # DELETE /artists/1
  # DELETE /artists/1.json
  def destroy
    @artist.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_artist
    @artist = Artist.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def artist_params
    params.require(:artist).permit(:name)
  end
end
