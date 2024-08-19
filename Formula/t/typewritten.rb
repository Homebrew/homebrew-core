class Typewritten < Formula
  desc "Minimal zsh prompt"
  homepage "https://typewritten.dev"
  url "https://github.com/reobin/typewritten/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "db9165ea4490941d65bfa6d7d74ba0312e1667f5bbe712922a6d384bb5166aa6"
  license "MIT"
  head "https://github.com/reobin/typewritten.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "e8c61e69280a332dc55d48a679c26ab03a2daf4ed025e9b2ced40b3966bfd7cb"
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
