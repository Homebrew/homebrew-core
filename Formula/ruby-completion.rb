class RubyCompletion < Formula
  desc "Bash completion for Ruby"
  homepage "https://github.com/mernen/completion-ruby"
  url "https://github.com/mernen/completion-ruby.git",
      revision: "f3e4345042b0cc48317e45b673dfd3d23904b9a7"
  version "2"
  license "MIT"
  head "https://github.com/mernen/completion-ruby.git", branch: "main"

  livecheck do
    skip "No version information available to check"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "534da18dd29bafad68930a70b41d94de09a99d0c4cf01e62bdb1a3c3f49fd3f3"
  end

  def install
    bash_completion.install "completion-ruby" => "ruby"
  end

  test do
    assert_match "-F __ruby",
      shell_output("source #{bash_completion}/ruby && complete -p ruby")
  end
end
