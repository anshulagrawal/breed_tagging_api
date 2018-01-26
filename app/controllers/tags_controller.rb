class TagsController < ApplicationController
  # POST /breeds/:breed_id/tags
  def create
    breed_id, tag_names = nil, nil
    safe_whitelist do
      params.require(:breed_id)
      breed_id = params[:breed_id]
      tag_names = params.require(:tags).map{|tag|
        tag.require(:name)
        tag[:name]
      }
    end
    breed = Breed.where(id: breed_id).first
    raise InvalidJson.new("Breed not available to update") if breed.blank?
    safe_persist do
      breed.add_tags!(tag_names)
    end
    render json: HashGen::breeds([breed]), format: :json, status: ResponseCodes::SuccessCodes::Ok
  end
  # GET /breeds/:breed_id/tags
  def show_by_breed
    breed_id = nil
    safe_whitelist do
      params.require(:breed_id)
      breed_id = params[:breed_id]
    end
    breed = Breed.where(id: breed_id).first
    raise InvalidJson.new("Breed not available for displaying tags") if breed.blank?
    render json: HashGen::tags(breed.tags), format: :json, status: ResponseCodes::SuccessCodes::Ok
  end
  # GET /tags/:id
  def show
    tag_id = nil
    safe_whitelist do
      tag_id = params.require(:id)
      raise "Invalid tag id" unless tag_id.is_a?(String)
    end
    tag = Tag.where(id: tag_id).first
    raise InvalidJson.new("Tag not available") if tag.blank?
    render json: HashGen::tags([tag]), format: :json, status: ResponseCodes::SuccessCodes::Ok
  end
  # GET /tags
  def index
    render json: HashGen::tags(Tag.all), format: :json, status: ResponseCodes::SuccessCodes::Ok
  end
  # PUT/PATCH /tags/:id
  def update
    tag_id, tag_name = nil, nil
    safe_whitelist do
      params.require(:id)
      tag_id = params[:id]
      tag_name = params.require(:name)
      raise "Invalid name" unless tag_name.is_a?(String) || tag_name.blank?
    end
    tag = Tag.where(id: tag_id).first
    raise InvalidJson.new("Tag not available for deletion") if tag.blank?
    tag.name = tag_name
    safe_persist do
      tag.save!
    end
    render json: HashGen::tags([tag]), format: :json, status: ResponseCodes::SuccessCodes::Ok
  end
  # DELETE /tags/:id
  def destroy
    tag_id = nil
    safe_whitelist do
      tag_id = params.require(:id)
      raise "Invalid tag id" unless tag_id.is_a?(String)
    end
    tag = Tag.where(id: tag_id).first
    raise InvalidJson.new("Tag not available for deletion") if tag.blank?
    safe_persist do
      raise "Unable to delete tag: #{tag.id}" unless tag.destroy
    end
    render json: successful_delete_response("Tag", tag_id), format: :json, status: ResponseCodes::SuccessCodes::Ok
  end
end
