FactoryBot.define do
  factory :message do
    content {Faker::Lorem.sentence}
    association :user
    association :room
    # ↑後でpictweetにこんな記述あったか調べて

    after(:build) do |message|
      message.image.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png')
      # 設定したパスのファイル（public/images/test_image.png）を、test_image.pngというファイル名で保存
    end
  end
end