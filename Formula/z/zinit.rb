class Zinit < Formula
  desc "Flexible and fast Zsh plugin manager"
  homepage "https://zdharma-continuum.github.io/zinit/wiki/"
  url "https://github.com/zdharma-continuum/zinit/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "ffa05360a150ef4745439d784338e5b17984851b86df4da125028db3a12b53b2"
  license "MIT"
  head "https://github.com/zdharma-continuum/zinit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d99e7800aa291676e5a74d0ed4f4e8ee77d3d8baa8492f34379368a3bff1743f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d99e7800aa291676e5a74d0ed4f4e8ee77d3d8baa8492f34379368a3bff1743f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d99e7800aa291676e5a74d0ed4f4e8ee77d3d8baa8492f34379368a3bff1743f"
    sha256 cellar: :any_skip_relocation, ventura:        "77cb19579625c9c29b0fc0bdb8ab6831f0adeaa941a56764e1679a43ee3763c8"
    sha256 cellar: :any_skip_relocation, monterey:       "77cb19579625c9c29b0fc0bdb8ab6831f0adeaa941a56764e1679a43ee3763c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "77cb19579625c9c29b0fc0bdb8ab6831f0adeaa941a56764e1679a43ee3763c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d99e7800aa291676e5a74d0ed4f4e8ee77d3d8baa8492f34379368a3bff1743f"
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
