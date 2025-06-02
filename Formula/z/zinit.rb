class Zinit < Formula
  desc "Flexible and fast Zsh plugin manager"
  homepage "https://zdharma-continuum.github.io/zinit/wiki/"
  url "https://github.com/zdharma-continuum/zinit/archive/refs/tags/v3.14.0.tar.gz"
  sha256 "4707baaad983d2ea911b4c2fddde9e7876593b3dc969a5efd9d387c9e3d03bb3"
  license "MIT"
  head "https://github.com/zdharma-continuum/zinit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "804a9d5dcb76db825078745d20af231ff45870f86f0d5564688067de7294c2a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "804a9d5dcb76db825078745d20af231ff45870f86f0d5564688067de7294c2a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "804a9d5dcb76db825078745d20af231ff45870f86f0d5564688067de7294c2a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "df0bb7bf2ab57d6fb71f1e1f1732bc1854cb513b4e2052987d69e395975824d8"
    sha256 cellar: :any_skip_relocation, ventura:       "df0bb7bf2ab57d6fb71f1e1f1732bc1854cb513b4e2052987d69e395975824d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "804a9d5dcb76db825078745d20af231ff45870f86f0d5564688067de7294c2a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "804a9d5dcb76db825078745d20af231ff45870f86f0d5564688067de7294c2a9"
  end

  uses_from_macos "zsh"

  def install
    prefix.install Dir["*"]
    man1.install_symlink prefix/"doc/zinit.1"
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
