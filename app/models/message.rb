class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_one_attached :image
  # 1対1の関係で紐づけるメソッド
  # :imageはファイル名で、パラメータのキーにもなる
  # imageがどこから来たのかわからない、imageファイルなんて作ってない

  validates :content, presence: true
end
