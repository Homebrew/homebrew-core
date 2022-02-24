class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v3.16.4.tar.gz"
  sha256 "b2844fb24e2cc24de8a296b61088a04df274ae65a2e797583dc18586bff6ebe9"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c2f1db22f7840b01bfda94950c7445236ddcf64a5888f2148e5f3a32379d61d1"
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
