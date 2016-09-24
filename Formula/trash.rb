class Trash < Formula
  desc "CLI tool that moves files or folder to the trash"
  homepage "http://hasseg.org/trash/"
  url "https://github.com/ali-rantakari/trash/archive/v0.8.5.tar.gz"
  sha256 "1e08fdcdeaa216be1aee7bf357295943388d81e62c2c68c30c830ce5c43aae99"

  bottle do
    cellar :any_skip_relocation
    sha256 "a00374dc159ab870e2c1267280d63e3ac5f7e7256e300fcb282ad6638abd02f0" => :sierra
    sha256 "4a890c2c7e5fe136eff1df5552fc94e1f56c46f41ccfa43bc5892de08329a3f4" => :el_capitan
    sha256 "05ae485401cd5becced038755656b120b74e9cffd15358724ea5f7eea2411972" => :yosemite
    sha256 "f74b3d47c9208cb0ccee9d017b146052df8748f3bc4a2bb4525a1d6c5e55909a" => :mavericks
  end

  conflicts_with "osxutils", :because => "both install a trash binary"

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
