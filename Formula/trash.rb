class Trash < Formula
  desc "CLI tool that moves files or folder to the trash"
  homepage "https://hasseg.org/trash/"
  url "https://github.com/ali-rantakari/trash/archive/v0.9.2.tar.gz"
  sha256 "e8739c93d710ac4da721e16878e7693019d3a2ad7d8acd817f41426601610083"
  license "MIT"
  head "https://github.com/ali-rantakari/trash.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b452d67cdeeb52db0aaadd258bc3e214a5ea5ed37da698b45017b01457115ea6" => :catalina
    sha256 "d8ad5460b24a51a4a12b31ebf1a2887e9e86e029d061f6994c3c1caea7bf0551" => :mojave
    sha256 "0ef5ea924ba8d01398686657a839ad270796f3f10eee86d6522980d32038df9a" => :high_sierra
  end

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
