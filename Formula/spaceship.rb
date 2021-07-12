class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v3.13.1.tar.gz"
  sha256 "e93f8390d422c1ef486873887aa708155ec048111efcdb3f3997f7116ba0328c"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "eb03d37977136c8608375c41f20674c6771277a36b9aa28ba2c7080c28b52bb0"
    sha256 cellar: :any_skip_relocation, big_sur:       "eb03d37977136c8608375c41f20674c6771277a36b9aa28ba2c7080c28b52bb0"
    sha256 cellar: :any_skip_relocation, catalina:      "eb03d37977136c8608375c41f20674c6771277a36b9aa28ba2c7080c28b52bb0"
    sha256 cellar: :any_skip_relocation, mojave:        "eb03d37977136c8608375c41f20674c6771277a36b9aa28ba2c7080c28b52bb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4a62fdd9210d1c41e61a952d84ad15da1d2ede3aa9497ae696c62db72f5dd9c"
  end

  depends_on "zsh" => :test

  def install
    libexec.install "spaceship.zsh", "lib", "sections"
    zsh_function.install_symlink libexec/"spaceship.zsh" => "prompt_spaceship_setup"
  end

  test do
    ENV["SPACESHIP_CHAR_SYMBOL"] = "🍺"
    prompt = "setopt prompt_subst; autoload -U promptinit; promptinit && prompt -p spaceship"
    assert_match ENV["SPACESHIP_CHAR_SYMBOL"], shell_output("zsh -c '#{prompt}'")
  end
end
