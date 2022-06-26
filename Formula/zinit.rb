class Zinit < Formula
  desc "Flexible and fast Zsh plugin manager"
  homepage "https://zdharma-continuum.github.io/zinit/wiki/"
  url "https://github.com/zdharma-continuum/zinit/archive/refs/tags/v3.7.tar.gz"
  sha256 "dcd7ded70255a576a4612edb743650f83e688bd4a4b473bbdafeddb473bde3c9"
  license "MIT"
  head "https://github.com/zdharma-continuum/zinit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afcbf0b575f8770b92070e69d701fa4bd3fee4d612d09584d37ecac78e56bf83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c8965601c60d2160e1595b890653f50ad60ea07cf29777f3f008c0f93635c00"
    sha256 cellar: :any_skip_relocation, monterey:       "4b30dc6fac85c8e7db22dd1c3ad9045319a31f9aa1bf3b64216d713170ff2aa7"
    sha256 cellar: :any_skip_relocation, big_sur:        "15c6a0ace8050fcfeb735c1a0e4dd916b55da4ce74735ba7e5de48d268e20565"
    sha256 cellar: :any_skip_relocation, catalina:       "15c6a0ace8050fcfeb735c1a0e4dd916b55da4ce74735ba7e5de48d268e20565"
    sha256 cellar: :any_skip_relocation, mojave:         "15c6a0ace8050fcfeb735c1a0e4dd916b55da4ce74735ba7e5de48d268e20565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c8965601c60d2160e1595b890653f50ad60ea07cf29777f3f008c0f93635c00"
  end

  uses_from_macos "zsh"

  def install
    man1.install "doc/zinit.1"
    prefix.install Dir["*"]
  end

  def caveats
    <<~EOS
      To activate zinit, add the following to your ~/.zshrc:
        source #{opt_prefix}/zinit.zsh
    EOS
  end

  test do
    system "zsh", "-c", "source #{opt_prefix}/zinit.zsh && zinit load zsh-users/zsh-autosuggestions"
  end
end
