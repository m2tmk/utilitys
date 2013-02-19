# -*- coding: utf-8 -*-
require 'date'
require 'active_support/core_ext/date/calculations'
require 'active_support/core_ext/date_time/calculations'
require 'active_support/core_ext/time/calculations'

module Calculator
  # 金利額計算
  # 金利額 = (元金 * 日数 / 1年間の日数) * 金利
  module Interest
    # 日数は計算開始日から計算終了日までの片端日数とする。
    # 計算結果の端数は切捨。
    #
    # params:
    #   principal  : 元金
    #   rate       : 手数料率(金利)
    #   from       : 計算開始日
    #   to         : 計算終了日
    #   days_of_year : 1年間の日数(デフォルト365)
    def self.calc(principal, rate, from_date, to_date, days_of_year=365)
     (principal * one_end(from_date, to_date) / days_of_year ) * rate
    end

    # 片端日数の算出
    def self.one_end(from, to)
     (to - from).to_i
    end

    def self.parse(from_date, to_date, cutoff_day)# -> Terms
        terms = []

        cutoff_date = from_date.change(:day => cutoff_day)

        terms << Range.new(from_date, cutoff_date, true)

        while cutoff_date < to_date
            from_date = cutoff_date + 1

            cutoff_date = (from_date.beginning_of_month >> 1).change(:day => cutoff_day)
            cutoff_date = to_date if to_date <= cutoff_date

            terms << Range.new(from_date, cutoff_date, true)
        end

        terms
    end
  end

  class Rule
    attr_reader :principal, :rate, :from_date, :to_date

    def initialize(principal, rate, from_date, to_date)
        @principal = principal
        @rate = rate
        @from_date = from_date
        @to_date = to_date
    end
  end
end
