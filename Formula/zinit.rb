class Zinit < Formula
  desc "Flexible and fast Zsh plugin manager"
  homepage "https://zdharma-continuum.github.io/zinit/wiki/"
  url "https://github.com/zdharma-continuum/zinit/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "634cc5a69d7f804935ccf7198c70151fae4783bf3eb25100f27fdc394c2518a5"
  license "MIT"
  head "https://github.com/zdharma-continuum/zinit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "089b7e3f89a494031391647bfed6fb44b3b34c5a3e86d7f3d1c7a1545cc0aac9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "089b7e3f89a494031391647bfed6fb44b3b34c5a3e86d7f3d1c7a1545cc0aac9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "089b7e3f89a494031391647bfed6fb44b3b34c5a3e86d7f3d1c7a1545cc0aac9"
    sha256 cellar: :any_skip_relocation, ventura:        "d3bea09b4e34937f7a725ffaf70a85e895f6cc3a09114a8155c9a8afb6e97065"
    sha256 cellar: :any_skip_relocation, monterey:       "d3bea09b4e34937f7a725ffaf70a85e895f6cc3a09114a8155c9a8afb6e97065"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3bea09b4e34937f7a725ffaf70a85e895f6cc3a09114a8155c9a8afb6e97065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "089b7e3f89a494031391647bfed6fb44b3b34c5a3e86d7f3d1c7a1545cc0aac9"
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
