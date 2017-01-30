class Upx < Formula
  desc "Compress/expand executable files"
  homepage "https://upx.github.io/"
  url "https://github.com/upx/upx/releases/download/v3.93/upx-3.93-src.tar.xz"
  sha256 "893f1cf1580c8f0048a4d328474cb81d1a9bf9844410d2fd99f518ca41141007"
  head "https://github.com/upx/upx.git", :branch => :devel

  bottle do
    cellar :any_skip_relocation
    sha256 "3110b0c6ab650dfda7f1f5f8a1e6ff3c27f6f47b3680fe647a792d7b87356179" => :sierra
    sha256 "c647eabba12a956d385824825b408350f8bb1e0a8cd3052ead4f816e2fdc77fa" => :el_capitan
    sha256 "bc0df739884aef757c1f88dfe9b27e6d6e63ab5926c296d27f2a9a6e89fdd7fa" => :yosemite
  end

  depends_on "ucl"

  def install
    system "make", "all"
    bin.install "src/upx.out" => "upx"
    man1.install "doc/upx.1"
  end

  test do
    cp "#{bin}/upx", "."
    chmod 0755, "./upx"

    system "#{bin}/upx", "-1", "./upx"
    system "./upx", "-V" # make sure the binary we compressed works
    system "#{bin}/upx", "-d", "./upx"
  end
end
