class Upx < Formula
  desc "Compress/expand executable files"
  homepage "https://upx.github.io/"
  url "https://github.com/upx/upx/releases/download/v3.94/upx-3.94-src.tar.xz"
  sha256 "81ef72cdac7d8ccda66c2c1ab14f4cd54225e9e7b10cd40dd54be348dbf25621"
  head "https://github.com/upx/upx.git", :branch => :devel

  bottle do
    cellar :any_skip_relocation
    sha256 "c5af4e4d7cf49c8a91dfb50d79be814a9a30453c738d4addb56022781762af8c" => :sierra
    sha256 "4e00d30ed448c287c1210acb27f29214a60748125d7c500a5e180f1484fa089c" => :el_capitan
    sha256 "cfee86cc35770ad67a5b86c2eca8197063c3be6264cbf4c3a6b32a142f1b3356" => :yosemite
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
