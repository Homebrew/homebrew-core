class Trash < Formula
  desc "CLI tool that moves files or folder to the trash"
  homepage "https://hasseg.org/trash/"
  url "https://github.com/ali-rantakari/trash/archive/v0.9.2.tar.gz"
  sha256 "e8739c93d710ac4da721e16878e7693019d3a2ad7d8acd817f41426601610083"
  license "MIT"
  head "https://github.com/ali-rantakari/trash.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60186a8823abc9dd734475e3f787edd7c2d6a2254fff25b7289de2db15447099"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "541af91d1cb128aa743460a529a3dcab5bac63b61ccde0a60d73aee23ab7d5c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11c0c85ec692ea6d4a125070f0a6ca576aff991608a6c9632b984cbf983e2481"
    sha256 cellar: :any_skip_relocation, ventura:        "539093ca74c72ed8be974fd9042b14f55cde0ef2c1fadbedc7343099a394593e"
    sha256 cellar: :any_skip_relocation, monterey:       "09b8ac7ade28ca59bd578b90680ece838a507b90b35e44d06a16f4d8ab9ae6e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "403ba52ce97d38535e1d127ca227afd4ea2d0e0c8b414118dbc5376c9ed8f094"
    sha256 cellar: :any_skip_relocation, catalina:       "b452d67cdeeb52db0aaadd258bc3e214a5ea5ed37da698b45017b01457115ea6"
    sha256 cellar: :any_skip_relocation, mojave:         "d8ad5460b24a51a4a12b31ebf1a2887e9e86e029d061f6994c3c1caea7bf0551"
    sha256 cellar: :any_skip_relocation, high_sierra:    "0ef5ea924ba8d01398686657a839ad270796f3f10eee86d6522980d32038df9a"
  end

  depends_on :macos

  conflicts_with "macos-trash", because: "both install a `trash` binary"
  conflicts_with "trash-cli", because: "both install a `trash` binary"

  def install
    system "make"
    system "make", "docs"
    bin.install "trash"
    man1.install "trash.1"
  end

  test do
    system "#{bin}/trash"
  end
end
