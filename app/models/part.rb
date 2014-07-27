class Part < ActiveRecord::Base
  belongs_to :project
  has_many :print_jobs
  has_one :model_file

  def self.available
    where("id NOT IN (?)", claimed.select(:part_id))
  end

  def self.claimed
    joins(:print_jobs).where("aasm_state != 'rejected'")
  end

  def claim_for_user(user)
    print_jobs.create(
      project_id: project_id,
      user_id: user.id,
    )
  end

  def download_url
    if model_file && model_file.file?
      model_file.file.url
    else
      # FIXME: temporary support for old style model_url on Part
      model_url
    end
  end

  def preview_url(size=nil)
    if model_file && model_file.render?
      model_file.render.url(size)
    else
      # FIXME: temporary support for old style model_preview_url on Part
      model_preview_url
    end
  end
end
