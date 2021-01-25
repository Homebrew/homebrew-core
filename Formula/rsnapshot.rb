class Rsnapshot < Formula
  desc "File system snapshot utility (based on rsync)"
  homepage "https://www.rsnapshot.org/"
  url "https://github.com/rsnapshot/rsnapshot/releases/download/1.4.3/rsnapshot-1.4.3.tar.gz"
  sha256 "2b0c7aad3e14e0260513331425a605d73c3bdd7936d66d418d7714a76bc55bd1"
  license "GPL-2.0"
  head "https://github.com/rsnapshot/rsnapshot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "58392bc53c467eaab2d62cf6ffbf6598f0a709e679c92430ed8583209da7cccf" => :big_sur
    sha256 "debc885727c81ec84b780d5ebf84e94531a96a45a1c5b6151f5e4cc9cbe7f162" => :arm64_big_sur
    sha256 "e195b17e2c28a787e6bc183c3f57397256fba91c8d5c490f3c24576033d39a74" => :catalina
    sha256 "e195b17e2c28a787e6bc183c3f57397256fba91c8d5c490f3c24576033d39a74" => :mojave
    sha256 "e195b17e2c28a787e6bc183c3f57397256fba91c8d5c490f3c24576033d39a74" => :high_sierra
  end

  uses_from_macos "rsync" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/rsnapshot", "--version"
  end
end
