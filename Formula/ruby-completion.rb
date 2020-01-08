class RubyCompletion < Formula
  desc "Bash completion for Ruby"
  homepage "https://github.com/mernen/completion-ruby"
  url "https://github.com/mernen/completion-ruby.git",
    :revision => "f3e4345042b0cc48317e45b673dfd3d23904b9a7"
  version "2"
  head "https://github.com/mernen/completion-ruby.git"

  bottle :unneeded

  def install
    bash_completion.install "completion-ruby" => "ruby"
  end

  test do
    assert_match "-F __ruby",
      shell_output("source #{bash_completion}/ruby && complete -p ruby")
  end
end
