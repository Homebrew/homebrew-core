class RailsCompletion < Formula
  desc "Bash completion for Rails"
  homepage "https://github.com/mernen/completion-ruby"
  url "https://github.com/mernen/completion-ruby/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "cbcd002bba2a43730cff54f5386565917913d9dec16dcd89345fbe298fe4316b"
  license "MIT"
  version_scheme 1
  head "https://github.com/mernen/completion-ruby.git", branch: "main"

  livecheck do
    formula "ruby-completion"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c8a61b7b584a29b0be33464a28714a01f798a7fcaceaf1c96f1b447363bc51f3"
  end

  def install
    bash_completion.install "completion-rails" => "rails"
  end

  test do
    assert_match "-F __rails",
      shell_output("bash -c 'source #{bash_completion}/rails && complete -p rails'")
  end
end
