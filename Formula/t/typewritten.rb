class Typewritten < Formula
  desc "Minimal zsh prompt"
  homepage "https://typewritten.dev"
  url "https://github.com/reobin/typewritten/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "03dcd8239e66cbeac7fa31457bae8355d1fc05fb49dcb05b77ed40f4771226fd"
  license "MIT"
  head "https://github.com/reobin/typewritten.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8a6b8fe7ec007b83306cbb94c0d4fed1f6a39fb4f3f053cce9420e4ddbca6137"
  end

  depends_on "zsh" => :test

  def install
    libexec.install "typewritten.zsh", "async.zsh", "lib"
    zsh_function.install_symlink libexec/"typewritten.zsh" => "prompt_typewritten_setup"
  end

  test do
    prompt = "setopt prompt_subst; autoload -U promptinit; promptinit && prompt -p typewritten"
    assert_match "❯", shell_output("zsh -c '#{prompt}'")
  end
end
