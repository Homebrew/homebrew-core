# typed: strict

class Homebrew::Cmd::CheckCiStatusCmd
  sig { returns(Homebrew::Cmd::CheckCiStatusCmd::Args) }
  def args; end
end

class Homebrew::Cmd::CheckCiStatusCmd::Args < Homebrew::CLI::Args
  sig { returns(T::Boolean) }
  def cancel?; end

  sig { returns(T::Boolean) }
  def long_timeout_label?; end
end
