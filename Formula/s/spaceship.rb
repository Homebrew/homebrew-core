class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh/"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/refs/tags/v4.22.6.tar.gz"
  sha256 "02da1413520241668141041f82284410dad5d3b4379a4d21b346ee206ee5f2be"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6e24fdbc475fdae434850d6e8bc3558b2d78e949e92de709731e03023c5641eb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6e24fdbc475fdae434850d6e8bc3558b2d78e949e92de709731e03023c5641eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6e24fdbc475fdae434850d6e8bc3558b2d78e949e92de709731e03023c5641eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0620325a81d139ec31ccbb7948c49b6ad1470821f10e3cf52c41f867035047dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "84cdbdd74a46f6d974edeb8fde461a15ac22e95f3f611a77a413bf8272892f62"
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
