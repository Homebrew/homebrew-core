class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v4.12.0.tar.gz"
  sha256 "84a50a757a64d4f6645ba1294e66867cc4252538ebda3d049e9cbf1258421b18"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e673550882e891164590e6c150dbc23beb8610ff4b8cc1f215e3922ae8b0ad2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7c6092d057c96f734e84d8218757f9345d1b3998fe00a8e27e65169c284c3b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c0d6b6c11754bd1c4d62f68240471fc6f995f1cbe379599ca89e02c2ffe9427"
    sha256 cellar: :any_skip_relocation, ventura:        "dac9f374505b3d2e3f8c80014b52e00bc9e01e67eb536d33df4377fe2dbafb75"
    sha256 cellar: :any_skip_relocation, monterey:       "db5bfec69088c6345aa6bb119e30a423668fa008f9f0ef273f1c8759200d17c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "e48df55727ed8c4a98d0bcdc0d504783c986aa59d10adcb05737b50a7d8d474a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "519e839acadb81051e2191ac078654deffd9c804119d53356f3f98f444ee232d"
  end

  depends_on "zsh-async"
  uses_from_macos "zsh" => :test

  def install
    system "make", "compile"
    prefix.install Dir["*"]
  end

  def caveats
    <<~EOS
      To activate Spaceship, add the following line to ~/.zshrc:
        source "#{opt_prefix}/spaceship.zsh"
      If your .zshrc sets ZSH_THEME, remove that line.
    EOS
  end

  test do
    assert_match "SUCCESS",
      shell_output("zsh -fic '. #{opt_prefix}/spaceship.zsh && (( ${+SPACESHIP_VERSION} )) && echo SUCCESS'")
  end
end
