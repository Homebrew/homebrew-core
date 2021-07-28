class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v3.13.4.tar.gz"
  sha256 "c5691a555a75d4c117845e22d92149b91a8ffa8864b9988f99ca8fda07dabe80"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5ff73961b84f58ba58032afa5c47f40180f69375638fa4de731ed72e189f086f"
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
