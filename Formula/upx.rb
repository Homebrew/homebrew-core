class Upx < Formula
  desc "Compress/expand executable files"
  homepage "https://upx.github.io/"
  url "https://github.com/upx/upx/releases/download/v3.93/upx-3.93-src.tar.xz"
  sha256 "893f1cf1580c8f0048a4d328474cb81d1a9bf9844410d2fd99f518ca41141007"
  head "https://github.com/upx/upx.git", :branch => :devel

  bottle do
    cellar :any_skip_relocation
    sha256 "0d02e380888bf408a7000c2894c23adcb2922e35ce92d36135dfefec2a7a099e" => :sierra
    sha256 "c82e4c5cfa454ba997f4dd7a53f072a5cea34d43f31cddcd72b8663ad0d073bf" => :el_capitan
    sha256 "9fd0ce75bd361d27e26cfa4f76bfa3e16ee8f791909899342e530bc28290e4c1" => :yosemite
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
