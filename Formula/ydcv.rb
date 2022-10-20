class Ydcv < Formula
  include Language::Python::Virtualenv

  desc "YouDao Console Version"
  homepage "https://github.com/felixonmars/ydcv"
  url "https://files.pythonhosted.org/packages/1f/29/17124ebfdea8d810774977474a8652018c04c4a6db1ca413189f7e5b9d52/ydcv-0.7.tar.gz"
  sha256 "53cd59501557496512470e7db5fb14e42ddcb411fe4fa45c00864d919393c1da"
  license "GPL-3.0"
  revision 4
  head "https://github.com/felixonmars/ydcv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15a2f9b94d39645328338ffb95aa4ba058bc16b1dbe097af765c1ee7aa0b0a37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15a2f9b94d39645328338ffb95aa4ba058bc16b1dbe097af765c1ee7aa0b0a37"
    sha256 cellar: :any_skip_relocation, monterey:       "3961fb6ede937e194466d10568899cef0e9f7370348dcd758f4da4494c867d90"
    sha256 cellar: :any_skip_relocation, big_sur:        "3961fb6ede937e194466d10568899cef0e9f7370348dcd758f4da4494c867d90"
    sha256 cellar: :any_skip_relocation, catalina:       "3961fb6ede937e194466d10568899cef0e9f7370348dcd758f4da4494c867d90"
    sha256 cellar: :any_skip_relocation, mojave:         "3961fb6ede937e194466d10568899cef0e9f7370348dcd758f4da4494c867d90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35d3c655f6e3b7623dd7657adc51da6bd53629676710c450d7941378a9f62b4b"
  end

  depends_on "python@3.10"

  def install
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION"] = version

    zsh_completion.install "contrib/zsh_completion" => "_ydcv"
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      You need to add a config for API Key, read more at https://github.com/felixonmars/ydcv
    EOS
  end

  test do
    system "#{bin}/ydcv", "--help"
  end
end
