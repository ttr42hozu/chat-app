class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_one_attached :image
  # 1対1の関係で紐づけるメソッド
  # :imageはファイル名で、パラメータのキーにもなる
  # imageがどこから来たのかわからない、imageファイルなんて作ってない

  validates :content, presence: true, unless: :was_attached?
  # unless: :was_attached?でwas_attached?の返り値がfalseの場合、バリデーションによる検証を行うというオプション

  def was_attached?
    self.image.attached?
  end
  # 画像があればtrue、なければfalseを返す仕組み
end
