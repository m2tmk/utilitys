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
    def calc(base, days_of_year, rate)
      (base.to_f / days_of_year.to_f) * (rate * 0.01)
    end

    def one_end_base(principal, from_date, to_date)
      principal * one_end(from_date, to_date)
    end

    def both_end_base(principal, from_date, to_date)
      principal * both_end(from_date, to_date)
    end

    def calc_365(principal, from_date, to_date, rate)
      return 0 if from_date >= to_date

      calc(one_end_base(principal, from_date, to_date), 365, rate)
    end

    def calc_leap(principal, from_date, to_date, rate)
      return 0 if from_date >= to_date

      if from_date.leap? ^ to_date.leap?
        end_of_year = from_date.end_of_year

        t1 = calc(
                one_end_base(principal, from_date, end_of_year),
                days_of_year(end_of_year), rate)

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
    def one_end(from, to)
      return 0 if from >= to

      (to - from).to_i
    end

    # 両端日数の算出
    def both_end(from, to)
      return 0 if from >= to

      one_end(from, to) + 1
    end

    # 年間日数の算出
    def days_of_year(date)
      both_end(date.beginning_of_year, date.end_of_year)
    end

    def terms_by_cut_off_day(from_date, to_date, cut_off_day, &block)
      cut_off_date_proc = lambda do |from_date|
        if from_date.day < cut_off_day
          from_date.change(:day => cut_off_day)
        else
          (from_date.beginning_of_month >> 1).change(:day => cut_off_day)
        end
      end

      create_ranges(from_date, to_date, cut_off_date_proc, &block)
    end

    def terms_by_end_of_month(from_date, to_date, &block)
      cut_off_date_proc = lambda do |from_date|
        eom = from_date.end_of_month

        if from_date.day < eom.day
          eom
        else
          (from_date.beginning_of_month >> 1).end_of_month
        end
      end

      create_ranges(from_date, to_date, cut_off_date_proc, &block)
    end

    def create_ranges(from_date, to_date, cut_off_date_proc, &block)
      ranges = []

      while true
        cut_off_date = cut_off_date_proc.call(from_date)

        if to_date <= cut_off_date
          return ranges << create_range(from_date, to_date, &block)
        else
          ranges << create_range(from_date, cut_off_date, &block)
          from_date = cut_off_date
        end
      end
    end

    def create_range(from, to, &block)
      r = Range.new(from, to, true)
      block ? block.call(r) : r
    end
  end
end
