class RakeCompletion < Formula
  desc "Bash completion for Rake"
  homepage "https://github.com/JoeNyland/rake-completion"
  url "https://github.com/JoeNyland/rake-completion/archive/v1.0.1.tar.gz"
  sha256 "085801e62cb240311d77885778a603f649b3fd5d85ee279691d1d00bc060bba6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6d5a9f29cceb2470b61d563fc7d9d762e0a8b73f8e052d99103fad25e6301f62"
  end

  def install
    bash_completion.install "rake.sh" => "rake"
  end

  test do
    assert_match "-F _rakecomplete",
      shell_output("source #{bash_completion}/rake && complete -p rake")
  end
end
