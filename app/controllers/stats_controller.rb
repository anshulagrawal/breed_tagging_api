class StatsController < ApplicationController
  def breeds
    data = Breed.joins(:tags).group(:breed_id).pluck("breeds.id", "breeds.name", "group_concat(tags.id)", "count(tags.id)")
    render json: breed_stats(data), format: :json, status: ResponseCodes::SuccessCodes::Ok
  end
  def tags
    data = Tag.joins(:breeds).group(:tag_id).pluck("tags.id", "tags.name", "group_concat(breeds.id)", "count(breeds.id)")
    render json: tag_stats(data), format: :json, status: ResponseCodes::SuccessCodes::Ok
  end
end
