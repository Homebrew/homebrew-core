class RubyCompletion < Formula
  desc "Bash completion for Ruby"
  homepage "https://github.com/mernen/completion-ruby"
  url "https://github.com/mernen/completion-ruby/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "cbcd002bba2a43730cff54f5386565917913d9dec16dcd89345fbe298fe4316b"
  license "MIT"
  version_scheme 1
  head "https://github.com/mernen/completion-ruby.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d42c9cca43af3e04b6f0f6afc91b09543147e9e0af69495cafc8f0d1f60dcc14"
  end

  def install
    bash_completion.install "completion-ruby" => "ruby"
  end

  test do
    assert_match "-F __ruby",
      shell_output("bash -c 'source #{bash_completion}/ruby && complete -p ruby'")
  end
end
