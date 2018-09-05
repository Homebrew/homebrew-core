class Upx < Formula
  desc "Compress/expand executable files"
  homepage "https://upx.github.io/"
  revision 1
  head "https://github.com/upx/upx.git", :branch => :devel

  stable do
    url "https://github.com/upx/upx/releases/download/v3.94/upx-3.94-src.tar.xz"
    sha256 "81ef72cdac7d8ccda66c2c1ab14f4cd54225e9e7b10cd40dd54be348dbf25621"

    # Fixes decompressing Mach binaries: https://github.com/upx/upx/issues/161
    # Fixed upstream; this adjusts the patch to work on 3.94.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/9e37f000/upx/fix_decompression.patch"
      sha256 "a63d6da220c99b7507f1b6c0fd51008cdfd33fb66e22f374fc8f377a3f1a51d8"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d45aa693d18de2592fa5e776e042f22f7e13180ac463f130991c3ce815f9d3c1" => :mojave
    sha256 "4e7246364411fbf65dbb40c4876f12d6020e7fcb283d4825e2af38cd2e3d7816" => :high_sierra
    sha256 "8684eebcda6afe6b01ddf1e3ab7b03fc63cb7387003c2db1183c7953eed5b9f7" => :sierra
    sha256 "d52d66911679e34aa7174a7de9e88d3cfad63fddb31fdff3a7e8cb6b8d06d7e9" => :el_capitan
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
