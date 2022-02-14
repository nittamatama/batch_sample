require 'objspace'

namespace :ranks do
  namespace :chapter3 do
    desc 'chapter3 ゲーム内のユーザーランキング情報を更新する'
    task update: :environment do
      Benchmark.bm 10 do |r|
        r.report 'RanksUpdater' do
          RanksUpdater.new.update_all
        end
      end
      puts "used memory #{ObjectSpace.memsize_of_all * 0.001 * 0.001} MB"
    end
  end
end