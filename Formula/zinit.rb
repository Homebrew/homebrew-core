class Zinit < Formula
  desc "Flexible and fast Zsh plugin manager"
  homepage "https://zdharma-continuum.github.io/zinit/wiki/"
  url "https://github.com/zdharma-continuum/zinit/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "1c363b058e3df73652ed03f2f3ad2c3d2d8ecc96f8752905716df9258b86b9e7"
  license "MIT"
  head "https://github.com/zdharma-continuum/zinit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46aaecb6e6e6cc8248ad822c841b6dcae5cabc1f0639ef173164c42d51e65269"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46aaecb6e6e6cc8248ad822c841b6dcae5cabc1f0639ef173164c42d51e65269"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46aaecb6e6e6cc8248ad822c841b6dcae5cabc1f0639ef173164c42d51e65269"
    sha256 cellar: :any_skip_relocation, ventura:        "635551814b09b495f9d96f7f0bd7f5fa1615308843c70a1e5984e6e83557ff20"
    sha256 cellar: :any_skip_relocation, monterey:       "635551814b09b495f9d96f7f0bd7f5fa1615308843c70a1e5984e6e83557ff20"
    sha256 cellar: :any_skip_relocation, big_sur:        "635551814b09b495f9d96f7f0bd7f5fa1615308843c70a1e5984e6e83557ff20"
    sha256 cellar: :any_skip_relocation, catalina:       "635551814b09b495f9d96f7f0bd7f5fa1615308843c70a1e5984e6e83557ff20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46aaecb6e6e6cc8248ad822c841b6dcae5cabc1f0639ef173164c42d51e65269"
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
