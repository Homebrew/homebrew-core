class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v3.13.2.tar.gz"
  sha256 "b609ee67aae3f724f0ef65456a3b0ca82c16354c7e188e19e63e71a1d3615d92"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b30de1432f2653eeb7bb7fe26467e9117cfe31af469544d35c2e2a4f9bc71e9f"
    sha256 cellar: :any_skip_relocation, big_sur:       "b30de1432f2653eeb7bb7fe26467e9117cfe31af469544d35c2e2a4f9bc71e9f"
    sha256 cellar: :any_skip_relocation, catalina:      "b30de1432f2653eeb7bb7fe26467e9117cfe31af469544d35c2e2a4f9bc71e9f"
    sha256 cellar: :any_skip_relocation, mojave:        "b30de1432f2653eeb7bb7fe26467e9117cfe31af469544d35c2e2a4f9bc71e9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26cf92c2f5ee75b2d1fe64590b003df7464e3c97ca98ac4da8e18682b9a2217d"
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
