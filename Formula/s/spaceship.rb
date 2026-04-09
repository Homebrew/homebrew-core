class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh/"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/refs/tags/v4.22.1.tar.gz"
  sha256 "3199f900557d8e9fb33df4d5e28dfecad1d6fceff08064a03c7170d74de33290"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3bd1cb66f4e5f595cf2badf0c5aa107456789bb7d6da6d8aca9f950446cee18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3bd1cb66f4e5f595cf2badf0c5aa107456789bb7d6da6d8aca9f950446cee18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3047fd864383cf375ab8324190612fa14fe3cd451cca5680f5b9ac3e3cd8660c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9f47acb39ce52e21ed08705a7ecadf1f22835c7d0ea8b0472098b7f88b877e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed82358dff295635a330b4bda4fcdf6fca023d2e50dc0c57e720fe0c4284902d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2d105a40cba097ffaba082cb0005be54004788cf2631ebcfff47af891ca9324"
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
    assert_match "SUCCESS",
      shell_output("zsh -fic '. #{opt_prefix}/spaceship.zsh && (( ${+SPACESHIP_VERSION} )) && echo SUCCESS'")
  end
end
