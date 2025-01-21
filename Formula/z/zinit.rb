class Zinit < Formula
  desc "Flexible and fast Zsh plugin manager"
  homepage "https://zdharma-continuum.github.io/zinit/wiki/"
  url "https://github.com/zdharma-continuum/zinit/archive/refs/tags/v3.13.1.tar.gz"
  sha256 "41359f41815a6461cab50ff5ba0b94dc40adcdb3646c9e71021064146a2a336a"
  license "MIT"
  head "https://github.com/zdharma-continuum/zinit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "251ead382b6070b998adda0bbd0f77d130d2e3730ca439abed75e8f2408e08cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69effd5a739c9c7807ae7b4e6e981dc187fce2d46931a1586f5bd161ebf8f912"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69effd5a739c9c7807ae7b4e6e981dc187fce2d46931a1586f5bd161ebf8f912"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69effd5a739c9c7807ae7b4e6e981dc187fce2d46931a1586f5bd161ebf8f912"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d50550b04aeda82fad00b728ecee5d08361212c7f2e96ffb4f45ad8a35b1e92"
    sha256 cellar: :any_skip_relocation, ventura:        "5d50550b04aeda82fad00b728ecee5d08361212c7f2e96ffb4f45ad8a35b1e92"
    sha256 cellar: :any_skip_relocation, monterey:       "5d50550b04aeda82fad00b728ecee5d08361212c7f2e96ffb4f45ad8a35b1e92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69effd5a739c9c7807ae7b4e6e981dc187fce2d46931a1586f5bd161ebf8f912"
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
