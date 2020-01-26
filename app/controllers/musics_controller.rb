class MusicsController < ApplicationController
  before_action :set_music, only: [:show, :update, :destroy]

  # GET /musics
  # GET /musics.json
  def index
    return @musics = current_user.music.with_attached_file.with_attached_picture.includes(:artist, :album) if request.query_parameters.blank?
    unless request.query_parameters["artist_id"].nil?
      return @musics = current_user.music.where(artist_id: request.query_parameters["artist_id"])
    end
    unless request.query_parameters["album_id"].nil?
      @musics = current_user.music.with_attached_file.with_attached_picture.includes(:artist, :album).where(album_id: request.query_parameters["album_id"])
    end
  end

  # GET /musics/1
  # GET /musics/1.json
  def show
  end

  # POST /musics
  # POST /musics.json
  def create
    @music = current_user.music.new(music_params)

    if @music.save
      render :show, status: :created, location: @music
    else
      render json: @music.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /musics/1
  # PATCH/PUT /musics/1.json
  def update
    if @music.update(music_params)
      render :show, status: :ok, location: @music
    else
      render json: @music.errors, status: :unprocessable_entity
    end
  end

  # DELETE /musics/1
  # DELETE /musics/1.json
  def destroy
    @music.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_music
      @music = current_user.music.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def music_params
      params.require(:music).permit(:file, :filename)
    end
end
