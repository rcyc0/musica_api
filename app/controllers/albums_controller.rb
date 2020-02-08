class AlbumsController < ApplicationController
  before_action :set_album, only: [:show, :update, :destroy]

  # GET /albums
  # GET /albums.json
  def index
    @albums = Album.all.includes(:music)
  end

  # GET /albums/1
  # GET /albums/1.json
  def show
  end

  # POST /albums
  # POST /albums.json
  def create
    @album = Album.new(album_params)

    if @album.save
      render :show, status: :created, location: @album
    else
      render json: @album.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /albums/1
  # PATCH/PUT /albums/1.json
  def update
    if @album.update(album_params)
      render :show, status: :ok, location: @album
    else
      render json: @album.errors, status: :unprocessable_entity
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.json
  def destroy
    @album.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_album
    @album = Album.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def album_params
    params.require(:album).permit(:name, :artist_id)
  end
end
