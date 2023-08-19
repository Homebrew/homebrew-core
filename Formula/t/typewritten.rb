class Typewritten < Formula
  desc "Minimal zsh prompt"
  homepage "https://typewritten.dev"
  url "https://github.com/reobin/typewritten/archive/v1.5.1.tar.gz"
  sha256 "db9165ea4490941d65bfa6d7d74ba0312e1667f5bbe712922a6d384bb5166aa6"
  license "MIT"
  head "https://github.com/reobin/typewritten.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0ad832359f435b0616e314ad96ac7d067632edb2c70f983b019d1ab3503784ba"
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
