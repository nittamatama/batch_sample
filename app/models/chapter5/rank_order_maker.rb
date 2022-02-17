module Chapter5
  class RankOrderMaker
    def each_ranked_user
      rank = 1
      previous_score = 0

      users_sorted_by_score.each do |user|
        # 合計スコアが変わった場合は順位を更新
        rank += 1 if user.total_score < previous_score

        # app/models/ranks_updater.rb の create_ranksに書いた
        # Rank.create(user_id: user.id, rank: rank, score: user.total_score) を実行
        yield(user, rank)

        # previous_scoreを更新して、次の順位更新に備える
        previous_score = user.total_score
      end
    end

    private

    def users_sorted_by_score
      User
        .includes(:user_scores)  
        .all
        .select { |user| user.total_score.nonzero? }
        .sort_by { |user| user.total_score * -1 }
    end
  end
end