class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh/"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/refs/tags/v4.22.7.tar.gz"
  sha256 "e95d059da22c0bcf0f9543acb0077c361b70d43aceba0df5773681523461de87"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    manifest_sha256 "7a20d6398f0de18f1645c868a08df611dce2c2b6b8b8313bee6c56504893be73"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a602a00dee544f9a2b7db352f7c5e1f54cc81658e59cb4e5aaa2623ed7d495f8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a602a00dee544f9a2b7db352f7c5e1f54cc81658e59cb4e5aaa2623ed7d495f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a602a00dee544f9a2b7db352f7c5e1f54cc81658e59cb4e5aaa2623ed7d495f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2009ae7f117720650f917089c94be5f9c022f5406217015700628ed3a8e0df6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5073947b4cd107c0bc0a3148b63f1cf63ce0d4306777187df555eccd5a59a204"
  end

  depends_on "zsh-async"
  uses_from_macos "zsh" => :test

  def install
    system "make", "compile"
    prefix.install Dir["*"]
  end

  def caveats
    <<~EOS
      To activate Spaceship, add the following line to ~/.zshrc:
        source "#{opt_prefix}/spaceship.zsh"
      If your .zshrc sets ZSH_THEME, remove that line.
    EOS
  end

  test do
    # sourcing exits non-zero when `zcompile` cannot write beside the read-only keg, so check the prompt hook instead
    assert_match "SUCCESS",
      shell_output("zsh -fc '. #{opt_prefix}/spaceship.zsh 2>/dev/null; " \
                   "(( ${precmd_functions[(I)prompt_spaceship_precmd]} )) && echo SUCCESS'")
  end
end
