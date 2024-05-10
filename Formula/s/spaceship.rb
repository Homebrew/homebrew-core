class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  # site cert issue, https://github.com/spaceship-prompt/spaceship-prompt/issues/1431
  # homepage "https://spaceship-prompt.sh"
  homepage "https://github.com/spaceship-prompt/spaceship-prompt"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/refs/tags/v4.15.2.tar.gz"
  sha256 "d221478bf6cb9dee831a1941d93f929e0e4aac1f26ebc5001793359d871d0d40"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "18059208ffbd69278aca660686ff000a76aa0d0ea4ee11ae1453f6ed60499ac3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae48e4c9a3c8d3f3c48d3ef0973bc664dbc57c0e00057636122b03343de36973"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "629c68b4529420acd49d011c40d437de74c9df2aa5056cc44cc4bffb4e7b384d"
    sha256 cellar: :any_skip_relocation, sonoma:         "b25e4c33deaeee9a246457c6b9cc2076c6a3985cee91a45ea3bef7f46edd0371"
    sha256 cellar: :any_skip_relocation, ventura:        "0742cae26bfac136de1b0539e581d219c7e5a13367f7ed86f23eb914b3bce6f9"
    sha256 cellar: :any_skip_relocation, monterey:       "773c2166d7bca3b5fd0fdfd3a7f355183318d3304e78c92bc08b0e921361f0bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de70a9641df739dc0876ea55744a68832bf16e82ed7020cc03accff4aed3bf33"
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
