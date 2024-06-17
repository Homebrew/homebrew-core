class RakeCompletion < Formula
  desc "Bash completion for Rake"
  homepage "https://github.com/mernen/completion-ruby"
  url "https://github.com/mernen/completion-ruby/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "70b9ae9154076b561f0d7b2b74893258dc00168ded3e8686f14e349f4a324914"
  license "MIT"
  head "https://github.com/mernen/completion-ruby.git", branch: "main"

  livecheck do
    formula "ruby-completion"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3ab3230b051ec32510036be28e4d2bb89fb6cee106e74ec9a14f11b859d88adc"
  end

  def install
    bash_completion.install "completion-rake" => "rake"
  end

  test do
    assert_match "-F __rake",
      shell_output("bash -c 'source #{bash_completion}/rake && complete -p rake'")
  end
end
