class Zinit < Formula
  desc "Flexible and fast Zsh plugin manager"
  homepage "https://zdharma-continuum.github.io/zinit/wiki/"
  url "https://github.com/zdharma-continuum/zinit/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "2d3b6a742fac9d78a4c9c084837338c9dde4214f7e050a261bd8a64afc08a81c"
  license "MIT"
  head "https://github.com/zdharma-continuum/zinit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f3680c8222c88b4dc8497acbfb373e546c07ebaee77dad10ca5ed8a45f149ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f3680c8222c88b4dc8497acbfb373e546c07ebaee77dad10ca5ed8a45f149ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f3680c8222c88b4dc8497acbfb373e546c07ebaee77dad10ca5ed8a45f149ce"
    sha256 cellar: :any_skip_relocation, ventura:        "b13c70a2e5d04306b425bc9f4d72380c5a048a3429174eba579403f2f5260267"
    sha256 cellar: :any_skip_relocation, monterey:       "b13c70a2e5d04306b425bc9f4d72380c5a048a3429174eba579403f2f5260267"
    sha256 cellar: :any_skip_relocation, big_sur:        "b13c70a2e5d04306b425bc9f4d72380c5a048a3429174eba579403f2f5260267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f3680c8222c88b4dc8497acbfb373e546c07ebaee77dad10ca5ed8a45f149ce"
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
