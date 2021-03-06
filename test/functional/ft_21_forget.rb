
#
# testing ruote
#
# Mon Jul 27 09:17:51 JST 2009
#

require File.join(File.dirname(__FILE__), 'base')

require 'ruote/participant'


class FtForgetTest < Test::Unit::TestCase
  include FunctionalBase

  def test_basic

    pdef = Ruote.process_definition do
      sequence do
        alpha :forget => true
        alpha
      end
    end

    @engine.register_participant :alpha do
      @tracer << "alpha\n"
    end

    #noisy

    wfid = @engine.launch(pdef)

    wait_for(wfid)
    wait_for(wfid)

    assert_equal %w[ alpha alpha ].join("\n"), @tracer.to_s

    #logger.log.each { |e| p e }

    assert_equal 1, logger.log.select { |e| e['action'] == 'ceased' }.size
    assert_equal 1, logger.log.select { |e| e['action'] == 'terminated' }.size
  end

  def test_forgotten_tree

    sp = @engine.register_participant :alpha, Ruote::StorageParticipant

    pdef = Ruote.process_definition do
      sequence do
        alpha :forget => true
      end
    end

    wfid = @engine.launch(pdef)

    wait_for(wfid)

    ps = @engine.process(wfid)

    assert_not_nil ps
    assert_equal 0, ps.errors.size
    assert_equal 1, ps.expressions.size

    fei = ps.expressions.first.fei
    assert_equal fei, ps.root_expression_for(fei).fei

    #puts "not sure..."
    #p ps.original_tree
    #p ps.current_tree
  end

  def test_forget_true_string

    pdef = Ruote.process_definition do
      concurrence :count => 1 do
        alpha :forget => 'true'
        bravo
      end
      charly
    end

    @engine.register_participant '.+' do |wi|
      @tracer << wi.participant_name + "\n"
    end

    wfid = @engine.launch(pdef)

    wait_for(wfid)
    wait_for(wfid)

    #assert_equal "alpha\nbravo\ncharly", @tracer.to_s
    assert_equal %w[ alpha bravo charly ], @tracer.to_a.sort
  end

  def test_forget_and_cursor

    pdef = Ruote.define do
      cursor do
        alpha :forget => true
        bravo
        rewind
      end
    end

    @engine.register_participant 'alpha', Ruote::NullParticipant
      # this participant never replies

    @engine.register_participant 'bravo', Ruote::NoOpParticipant
      # this one simply replies

    #@engine.noisy = true

    wfid = @engine.launch(pdef)

    @engine.wait_for(:bravo)
    @engine.wait_for(:bravo)

    assert_not_nil @engine.process(wfid)
  end
end

