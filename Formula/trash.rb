class Trash < Formula
  desc "CLI tool that moves files or folder to the trash"
  homepage "https://hasseg.org/trash/"
  url "https://github.com/ali-rantakari/trash/archive/v0.9.2.tar.gz"
  sha256 "e8739c93d710ac4da721e16878e7693019d3a2ad7d8acd817f41426601610083"
  head "https://github.com/ali-rantakari/trash.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa83a082a40fb46d6cdd954ad643c8be433bce1bb4f7f5e541d487cbdc2d920f" => :mojave
    sha256 "8ecc3fcedf8a31e799f04be6940850dcc6db11f2dc0f1db0fa3a3af1c49cac21" => :high_sierra
    sha256 "b30768556b816f51df0fc7d8016dec80d30a60c8402bf1238b9f9a68848677b1" => :sierra
    sha256 "75cebaa2b12cd75eeb1bb8deb4737639064f68f010cab94e378bd5ce727d4c34" => :el_capitan
  end

  conflicts_with "trash-cli", :because => "both install a `trash` binary"

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
