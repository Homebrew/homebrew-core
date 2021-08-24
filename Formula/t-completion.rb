class TCompletion < Formula
  desc "Completion for CLI power tool for Twitter"
  homepage "https://sferik.github.io/t/"
  url "https://github.com/sferik/t/archive/v3.1.0.tar.gz"
  sha256 "900ef6e3d6180b70bf2434503774ea5e1bf985b9110d4f051c44a191b08f6062"
  license "MIT"
  head "https://github.com/sferik/t.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6735212e9fee5e04fce9adaa96e09c20cc7508b8d26e1d85658825b0c50e85c7"
  end

  def install
    bash_completion.install "etc/t-completion.sh" => "t"
    zsh_completion.install "etc/t-completion.zsh" => "_t"
  end

  test do
    assert_match "-F _t",
      shell_output("source #{bash_completion}/t && complete -p t")
  end
end
