class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v3.12.6.tar.gz"
  sha256 "251e6bd72326ea4eb1e51632df8ab4bef6fc541849b870014459515280c60be5"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "aa63f75dd40c9ae84243a925451e37853dc565f886f70d8b3b4f377bf945d208"
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
