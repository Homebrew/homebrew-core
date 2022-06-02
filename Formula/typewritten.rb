class Typewritten < Formula
  desc "Minimal zsh prompt"
  homepage "https://typewritten.dev"
  url "https://github.com/reobin/typewritten/archive/v1.4.6.tar.gz"
  sha256 "dc8192a2cc969c8938ee81921ec8765c901f0a75b93c5c2082e4bea21b908e0c"
  license "MIT"
  head "https://github.com/reobin/typewritten.git", branch: "main"

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
