# 大量のテストデータを生成する
  - バッチ処理を開発するときは本番環境でどのくらいのデータ件数を取り扱うことになるのかを事前に見積もり
    できれば同じくらいの量のテストデータで動作確認をしておくべき
  - バッチ処理の改良は実行時間の短縮とメモリ消費量の削減と二段階に分けて進めていく
  - 実行時間を測定する
    - 実行時間を測定するためにBenchmarkを使用します。
      BenchmarkはRubyに標準で提供されているライブラリです。(2)
      - userはこのバッチ処理本体が使用したCPUの時間で、systemはこのバッチ処理を実行している間にOSが使用したCPUの時間
      - 最後のrealが実経過時間です。バッチ処理の実行時間はrealの項目で確認することができます
  - メモリ消費量を測定する
    - `ObjectSpace.memsize_of_all`を追加（標準ライブラリ）
  - 手順
    - テスト用のseedファイル作成(1)

# コード
  ```ruby
  # 1 大量のテストデータを作成

  user_amount = ENV['USER_AMOUNT'].to_i
  # この環境変数を変更することで任意の数のテストデータを作成することが可能

User.transaction do
  1.upto(user_amount) do |i|
    user = User.create(id: i, name: "#{i}人目のゲームユーザー")
    # テストデータ ユーザーごとの得点
    rand(30).times do
      UserScore.create(user_id: user.id, score: rand(1..100), received_at: Time.current.ago(rand(0..60).days))
    end
  end
end
```

  ```ruby
  # 2
  require 'objspace'

  namespace :ranks do
  namespace :chapter3 do
    desc 'chapter3 ゲーム内のユーザーランキング情報を更新する'
    task update: :environment do
      # ========= ここから削除 =========
      RanksUpdater.new.update_all
      # ========= ここまで削除 =========

      # ========= ここから追加 =========
      Benchmark.bm 10 do |r|
      # 10のパラメーターは出力結果1行目のラベルごとの文字幅を指定しています。あとは実行時間を測定したいコードをr.report 'RanksUpdater'で囲むことで測定対象が設定されます。
        r.report 'RanksUpdater' do
          RanksUpdater.new.update_all
        end
      end
        puts "used memory #{ObjectSpace.memsize_of_all * 0.001 * 0.001} MB"
      # r.reportの引数'RanksUpdater'は測定結果に表示するラベルを指定しています。今回は測定対象がひとつのみですがr.reportは複数設定することができ、ラベルをつけておくとどの処理の実行時間であるかがわかりやすくなります。
      
      # ObjectSpace.memsize_of_allは実行時点の消費メモリ量をバイト単位で取得することができるメソッドです。Rubyに標準で提供されているライブラリobjspaceの機能のひとつです。バイト単位ではわかりにくいため、今回は以下のように0.001を二回掛けることでメガバイト単位で表示させるようにしています。
    end
  end
end
```