# -*- coding: utf-8 -*-
require 'date'

module Calculator
  # 金利額計算
  # 金利額 = (元金 * 日数 / 1年間の日数) * 金利
  module Interest
    # 日数は起算日から満了日までの片端日数とする。
    # 1年間の日数は365日固定とする。
    # 計算結果の端数を切捨て
    #
    # params:
    #   principal  : 元金
    #   rate       : 手数料率(金利)
    #   from       : 金利計算の起算日
    #   to         : 金利計算の満了日
    def self.calc(principal, rate, from_date, to_date)
     interest = (principal * one_end(from_date, to_date)) / 365 * rate
     interest.truncate
    end

    # 片端日数の算出
    def self.one_end(from, to)
     (to - from).to_i
    end
  end
end
