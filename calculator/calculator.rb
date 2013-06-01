# -*- coding: utf-8 -*-
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

    def self.terms_by_cutoff_day(from_date, to_date, cutoff_day)
        terms = []

        cutoff_date = from_date.change(:day => cutoff_day)

        terms << create_range(from_date, to_date, cutoff_date)

        while cutoff_date < to_date
            from_date = cutoff_date + 1

            cutoff_date = (from_date.beginning_of_month >> 1).change(:day => cutoff_day)

            terms << create_range(from_date, to_date, cutoff_date)
        end

        terms
    end

    def self.terms_by_end_of_month(from_date, to_date)
        terms = []

        cutoff_date = from_date.end_of_month

        terms << create_range(from_date, to_date, cutoff_date)

        while cutoff_date < to_date
            from_date = cutoff_date + 1

            cutoff_date = from_date.end_of_month

            terms << create_range(from_date, to_date, cutoff_date)
        end

        terms
    end

    def self.create_range(from, to, cut_off)
        cut_off = to if to <= cut_off
        Range.new(from, cut_off, true)
    end
  end
end
