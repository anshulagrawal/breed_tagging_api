module RenderHelper
  extend ActiveSupport::Concern
  def successful_delete_response(obj_name, obj_id)
    {
      status: "Success",
      message: "Deleted #{obj_name}: #{obj_id}",
    }
  end
  def breed_stats(breed_data)
    {
      breed_stats: breed_data.map do |bd|
        {
          id: bd[0],
          name: bd[1],
          tag_ids: bd[2].split(',').map(&:to_i),
          tag_count: bd[3],
        }
      end
    }
  end
  def tag_stats(tag_data)
    {
      tag_stats: tag_data.map do |td|
        {
          id: td[0],
          name: td[1],
          breed_ids: td[2].split(',').map(&:to_i),
          breed_count: td[3],
        }
      end
    }
  end
end
