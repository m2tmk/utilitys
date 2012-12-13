# -*- coding: utf-8 -*-
require 'date'

module Calculator
  # 金額計算関連
  module Interest
    # 手数料額の計算
    #
    # 純粋な金利は、下記のように日割計算で算出される
    #   金利額 = (元金 * 日数 / １年間の日数) * 金利
    # しかし、このメソッドでは閏年をまたぐ場合と、毎月27日で締める処理を行う。
    # なお、締め日は前の期間の金利計算に含まれる
    #
    # 引数:
    #   principal  : 元金
    #   rate       : 手数料率(金利)
    #   cutoff     : 締日
    #   from       : 金利計算の起算日
    #   to         : 金利計算の満了日
    def self.calc(principal, rate, cutoff_day, from_date, to_date)
     rate = rate * 0.01
     # 締日
     cutoff_date = Date.new(from_date.year, from_date.month, cutoff_day)
     (principal * one_end(from_date, cutoff_date) / days_of_year(from_date, cutoff_date)) * rate
    end

    def self.days_of_year(from, to)
     if from.leap? && to.leap?
       366
     elsif !from.leap? && !to.leap?
       365
     end
    end

    def self.one_end(from, to)
     (to - from).to_i
    end

    def self.both_end(from, to)
     (to - from).to_i + 1
    end
  end
end
