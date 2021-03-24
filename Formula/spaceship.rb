class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://denysdovhan.com/spaceship-prompt"
  url "https://github.com/denysdovhan/spaceship-prompt/archive/v3.11.2.tar.gz"
  sha256 "8a4ed8fd84378a3f6566355a06eb877cd217afc48be69dee08041fd5e46b8e2d"
  license "MIT"
  head "https://github.com/denysdovhan/spaceship-prompt.git"

  bottle :unneeded

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
