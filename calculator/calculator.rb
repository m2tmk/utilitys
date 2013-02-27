# -*- coding: utf-8 -*-
require 'active_support/core_ext/date/calculations'
require 'active_support/core_ext/date_time/calculations'
require 'active_support/core_ext/time/calculations'

module Calculator
  # 金利額計算
  # 金利額 = (元金 * 日数 / 1年間の日数) * 利率  
  module Interest
    # 日数は計算開始日から計算終了日までの片端日数とする。
    # 計算結果の端数は切捨。
    #
    # params:
    #   base  : 基準額(元金 * 日数)
    #   days_of_year : 1年間の日数
    #   rate       : 利率(%)
    def self.calc(base, days_of_year, rate)
      rate_d = rate * 0.01
      (base.to_f / days_of_year.to_f) * rate_d
    end

    def self.one_end_base(principal, from_date, to_date)
      principal * one_end(from_date, to_date)
    end

    def self.both_end_base(principal, from_date, to_date)
      principal * both_end(from_date, to_date)
    end

    def self.calc_365(principal, from_date, to_date, rate)
      calc(one_end_base(principal, from_date, to_date), 365, rate)
    end

    def self.calc_leap(principal, from_date, to_date, rate)
      if from_date.leap? ^ to_date.leap?
        end_of_year = from_date.end_of_year

        t1 = calc(
                one_end_base(principal, from_date, end_of_year),
                days_of_year(from_date), rate)

        t2 = calc(
                one_end_base(principal, end_of_year, to_date),
                days_of_year(to_date), rate)

        t1 + t2
      else
        calc(
            one_end_base(principal, from_date, to_date),
            days_of_year(to_date), rate)
      end
    end

    # 片端日数の算出
    def self.one_end(from, to)
     (to - from).to_i
    end

    # 両端日数の算出
    def self.both_end(from, to)
      one_end(from, to) + 1
    end

    # 年間日数の算出
    def self.days_of_year(date)
      both_end(date.beginning_of_year, date.end_of_year)
    end

    def self.terms_by_cutoff_day(from_date, to_date, cutoff_day, &block)
        terms = []

        cutoff_date = from_date.change(:day => cutoff_day)

        t = create_range(from_date, to_date, cutoff_date)

        terms << (block ? block.call(t) : t)

        while cutoff_date < to_date
            from_date = cutoff_date

            cutoff_date = (from_date.beginning_of_month >> 1).change(:day => cutoff_day)

            t = create_range(from_date, to_date, cutoff_date)

            terms << (block ? block.call(t) : t)
        end

        terms
    end

    def self.terms_by_end_of_month(from_date, to_date, &block)
        terms = []

        cutoff_date = from_date.end_of_month

        t = create_range(from_date, to_date, cutoff_date)

        terms << (block ? block.call(t) : t)

        while cutoff_date < to_date
            from_date = cutoff_date

            cutoff_date = (from_date.beginning_of_month >> 1).end_of_month

            t = create_range(from_date, to_date, cutoff_date)

            terms << (block ? block.call(t) : t)
        end

        terms
    end

    def self.create_range(from, to, cut_off)
        cut_off = to if to <= cut_off
        Range.new(from, cut_off, true)
    end
  end
end
