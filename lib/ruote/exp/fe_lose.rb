#--
# Copyright (c) 2005-2011, John Mettraux, jmettraux@gmail.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# Made in Japan.
#++


module Ruote::Exp

  #
  # Never replies to its parent expression. Simply applies its first child,
  # if any, and just sits there.
  #
  # When cancelled, cancels its child (if any).
  #
  # In this example, the reminding sequence never replies to the concurrence.
  # The concurrence is only over when "alfred" replies.
  #
  #   Ruote.process_definition do
  #     concurrence :count => 1 do
  #       alfred
  #       lose do
  #         sequence do
  #           wait '2d'
  #           send_reminder_to_alfred
  #           wait '2h'
  #           send_alarm_to_boss
  #         end
  #       end
  #     end
  #   end
  #
  # Maybe shorter :
  #
  #   Ruote.process_definition do
  #     concurrence :count => 1 do
  #       alfred
  #       sequence do
  #         wait '2d'
  #         send_reminder_to_alfred
  #         wait '2h'
  #         send_alarm_to_boss
  #         lose
  #       end
  #     end
  #   end
  #
  # 'lose' on its own acts like a dead-end.
  #
  #
  # == the :lose attribute
  #
  # Every expression understands the 'lose' attribute :
  #
  #   Ruote.process_definition do
  #     concurrence :count => 1 do
  #       alfred
  #       sequence :lose => true do
  #         wait '2d'
  #         send_reminder_to_alfred
  #         wait '2h'
  #         send_alarm_to_boss
  #       end
  #     end
  #   end
  #
  # Probably produces definitions more compact than when using the 'lose'
  # expression.
  #
  class LoseExpression < FlowExpression

    names :lose

    def apply

      apply_child(0, h.applied_workitem)
    end

    def reply (workitem)

      # never gets called
    end
  end
end

