require 'rails_helper'

RSpec.describe "メッセージ投稿機能", type: :system do
  before do
    # 中間テーブルを作成して、usersテーブルとroomsテーブルのレコードを作成する
    @room_user = FactoryBot.create(:room_user)
    # 中間テーブルのレコード及びそこに紐づいているuserとroomのレコードを生成する（factoriesのroom_users.rbにassociationで定義しているからできる）
  end

  context '投稿に失敗したとき' do
    it '送る値が空の為、メッセージの送信に失敗すること' do
      # サインインする
      sign_in(@room_user.user)

      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)

      # DBに保存されていないことを確認する
      expect {
        find('input[name="commit"]').click
        # click_on("送信")でもいけたけど何か使ってはいけない理由がある？
      }.not_to change{ Message.count }
      # 元のページに戻ってくることを確認する
      expect(current_path).to eq room_messages_path(@room_user.room)
    end
  end

  context '投稿に成功したとき' do
    it 'テキストの投稿に成功すると、投稿一覧に遷移して、投稿した内容が表示されている' do
      # サインインする
      sign_in(@room_user.user)

      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)

      # 値をテキストフォームに入力する
      post = "テスト"
      fill_in 'message_content', with: post
      # 送信した値がDBに保存されていることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change {Message.count}.by(1)
      # 投稿一覧画面に遷移していることを確認する
      expect(current_path).to eq room_messages_path(@room_user.room)
      # 送信した値がブラウザに表示されていることを確認する
      expect(page).to have_content(post)
    end

    it '画像の投稿に成功すると、投稿一覧に遷移して、投稿した画像が表示されている' do
      # サインインする
      sign_in(@room_user.user)

      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)

      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')
      # public/images/test_image.pngを絶対パスに変換して定義？

      # 画像選択フォームに画像を添付する
      attach_file('message[image]', image_path, make_visible: true)
      # 第一引数にinput要素のname属性、第二引数に定義した画像のパス、第三引数は今回、input要素がtype="hidden"で隠れてしまっているためmake_visible: trueが必要

      # 送信した値がDBに保存されていることを確認する
      expect {
        find('input[name="commit"]').click
      }.to change {Message.count}.by(1)

      # 投稿一覧画面に遷移していることを確認する
      expect(current_path).to eq room_messages_path(@room_user.room)
      # 送信した画像がブラウザに表示されていることを確認する
      expect(page).to have_selector("img")
    end

    it 'テキストと画像の投稿に成功すること' do
      # サインインする
      sign_in(@room_user.user)

      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)

      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')

      # 画像選択フォームに画像を添付する
      attach_file('message[image]', image_path, make_visible: true)
      # 値をテキストフォームに入力する
      post = "テスト"
      fill_in 'message_content', with: post
      # 送信した値がDBに保存されていることを確認する
      expect {
        find('input[name="commit"]').click
      }.to change { Message.count }.by(1)
      # 送信した値がブラウザに表示されていることを確認する
      expect(page).to have_content(post)
      # 送信した画像がブラウザに表示されていることを確認する
      expect(page).to have_selector("img")
    end
  end
end