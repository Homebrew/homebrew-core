class Stow < Formula
  desc "Organize software neatly under a single directory tree (e.g. /usr/local)"
  homepage "https://www.gnu.org/software/stow/"
  url "https://ftp.gnu.org/gnu/stow/stow-2.3.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/stow/stow-2.3.1.tar.gz"
  sha256 "09d5d99671b78537fd9b2c0b39a5e9761a7a0e979f6fdb7eabfa58ee45f03d4b"

  bottle do
    cellar :any_skip_relocation
    sha256 "05b4b0aea83a487a80fcacdbf0d0e6d255e471cc0fda1b1cb162e9a83244d98b" => :mojave
    sha256 "e530cfa129ccce32a3a593c9ab09ea5c2976bef981d8ea3dc5af9f65e301e78a" => :high_sierra
    sha256 "93dc759da363883c6cbf581f957ed0c23abac5563de1680cb11721adc425dedc" => :sierra
    sha256 "0bf0a55711d83b08953a2de183d20cec481029dc95e9ea2ebd5049bf13ea8e1b" => :el_capitan
    sha256 "4062d438086c6f9e407db818d318ef9d857f7c909bd4730edfc174573f5958d4" => :yosemite
    sha256 "1f8ca6143dacc3cebb3551606b51a982b287c3b2f371010c7b10ca82ce89a393" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test").mkpath
    system "#{bin}/stow", "-nvS", "test"
  end
end
