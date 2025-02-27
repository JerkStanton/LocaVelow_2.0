class Bicycle < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_one_attached :image
  has_many :rentals, dependent: :nullify
  has_many :accessories, dependent: :destroy

  enum bicycle_type: { velo_de_route: 0, velo_de_montagne: 1, velo_hybride: 2, velo_de_ville: 3, bmx: 4, tandem: 5, velo_electrique: 6, velo_pliable: 7, velo_incline: 8, velo_cruiser: 9, velo_cargo: 10, velo_pignon_fixe: 11, velo_touring: 12, tricycle: 13, monocycle: 14 }

  enum size: { petit: 0, moyen: 1, grand: 2, tres_grand: 3, enfant: 4, autre: 5 }

  before_destroy :check_active_rentals

  def thumbnail
    return self.image.variant(resize_to_limit: [150, 150]).processed
  end

  def medium
    return self.image.variant(resize_to_limit: [300, 300]).processed
  end

  def large
    return self.image.variant(resize_to_limit: [600, 600]).processed
  end

  def extra_large
    return self.image.variant(resize_to_limit: [1200, 1200]).processed
  end
end

  private

    def check_active_rentals
      if rentals.where.not(rental_status: "completed").exists?
        errors.add(:base, "Cannot delete bicycle with active rentals.")
        throw :abort
      end
    end
  