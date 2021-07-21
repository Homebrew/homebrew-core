class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v3.13.3.tar.gz"
  sha256 "9b657616dcda876a98209683cd15a8d83d998639f30902cd7e89d2ddf49925c0"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8a86696ef32d02f4903082a4507c39c7f944e622f98a4cbce25825d68bcc0b4b"
    sha256 cellar: :any_skip_relocation, big_sur:       "8a86696ef32d02f4903082a4507c39c7f944e622f98a4cbce25825d68bcc0b4b"
    sha256 cellar: :any_skip_relocation, catalina:      "8a86696ef32d02f4903082a4507c39c7f944e622f98a4cbce25825d68bcc0b4b"
    sha256 cellar: :any_skip_relocation, mojave:        "8a86696ef32d02f4903082a4507c39c7f944e622f98a4cbce25825d68bcc0b4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "113c9937d9ca55710ffbbd8a92c9a5114bb6a7c7b2c3892301040a9e7f083dd9"
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
