class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://denysdovhan.com/spaceship-prompt"
  url "https://github.com/denysdovhan/spaceship-prompt/archive/v3.12.4.tar.gz"
  sha256 "399f828842b6c2ada6a078b46750bfbbcd4158400731db2c1511814ed6a9beb3"
  license "MIT"
  head "https://github.com/denysdovhan/spaceship-prompt.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bbb22c4558fe0684e2a26ce81b5f51dcd10b971eaab36f9218cbccda560503a4"
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
