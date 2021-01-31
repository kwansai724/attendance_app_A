class Attendance < ApplicationRecord
  belongs_to :user

  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }

  validate :finished_at_is_invalid_without_a_started_at
  validate :change_started_at_than_change_finished_at_fast_is_invalid

  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
  end

  def change_started_at_than_change_finished_at_fast_is_invalid
    if change_started_at.present? && change_finished_at.present?
    errors.add(:change_started_at, "より早い退勤時間は無効です") if change_started_at > change_finished_at && (tomorrow == false)
    end
  end
end
