require 'spec_helper'

describe SCSSLint::Linter::UsageName do
  context 'when no invalid usages exist' do
    let(:css) { <<-CSS }
      p {
        margin: 0;
      }
    CSS

    it { should_not report_lint }
  end

  context 'when a referenced variable name has a capital letter' do
    let(:css) { <<-CSS }
      p {
        margin: $badVar;
      }
    CSS

    it { should report_lint line: 2 }
  end

  context 'when a referenced variable name has an underscore' do
    let(:css) { <<-CSS }
      p {
        margin: $bad_var;
      }
    CSS

    it { should report_lint line: 2 }
  end

  context 'when a referenced function name has a capital letter' do
    let(:css) { <<-CSS }
      p {
        margin: badFunc();
      }
    CSS

    it { should report_lint line: 2 }
  end

  context 'when a referenced function name has an underscore' do
    let(:css) { <<-CSS }
      p {
        margin: bad_func();
      }
    CSS

    it { should report_lint line: 2 }
  end

  context 'when an included mixin name has a capital letter' do
    let(:css) { '@include badMixin();' }

    it { should report_lint line: 1 }
  end

  context 'when an included mixin name has an underscore' do
    let(:css) { '@include bad_mixin();' }

    it { should report_lint line: 1 }
  end

  context 'when function is a transform function' do
    %w[rotateX rotateY rotateZ
       scaleX scaleY scaleZ
       skewX skewY
       translateX translateY translateZ].each do |function|
      let(:css) { <<-CSS }
        p {
          transform: #{function}(2);
        }
      CSS

      it { should_not report_lint }
    end
  end

  context 'when a mixin contains keyword arguments with underscores' do
    let(:css) { '@include mixin($some_var: 4);' }

    it { should report_lint }
  end

  context 'when a mixin contains keyword arguments with hyphens' do
    let(:css) { '@include mixin($some-var: 4);' }

    it { should_not report_lint }
  end
end
