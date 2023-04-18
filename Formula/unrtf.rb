class Unrtf < Formula
  desc "RTF to other formats converter"
  homepage "https://www.gnu.org/software/unrtf/"
  url "https://ftp.gnu.org/gnu/unrtf/unrtf-0.21.10.tar.gz"
  mirror "https://ftpmirror.gnu.org/unrtf/unrtf-0.21.10.tar.gz"
  sha256 "b49f20211fa69fff97d42d6e782a62d7e2da670b064951f14bbff968c93734ae"
  license "GPL-3.0-or-later"
  head "https://hg.savannah.gnu.org/hgweb/unrtf/", using: :hg

  bottle do
    sha256 arm64_ventura:  "fbc5a59efc2a686ed6968150a3101f3e5121194eb8d505672bcf457b924085a1"
    sha256 arm64_monterey: "90ccbe686fedc51d5c3ef8f7088577a625e0ad3c3199632fcdc12d6e4e379f52"
    sha256 arm64_big_sur:  "7a091ab8d8e5a67f2821d1436300d6c41c9f15ead01a83ade9d38fc9cc2494b6"
    sha256 ventura:        "9371bbf23b01669c95f9742f469f0762e83c7f86c29234d9975f81936f8cdcb0"
    sha256 monterey:       "ca17c1fba58a187402fd76342528ce8da2c391d25622b425c2db15c8f0345d71"
    sha256 big_sur:        "198691cb483c4ae73b4c676d289bee8040937afe2881e07afbfb7b9f1e99a760"
    sha256 catalina:       "90361817069fa7149b201a0caf5e65abd872d10f8fdda154ff450511debf1d99"
    sha256 mojave:         "b038c53ba7341cc9365db6cf9d46c6f7c3feba843643168e24a12856a29a6dbb"
    sha256 high_sierra:    "9abc63bdeae500637c8e1d6d31c72be013d0f2cf8ad8e3f1cb6e3babe5b6d94a"
    sha256 sierra:         "4c9e869dad1a76bf4077d9e19cabf9d383ed914b5a1c348dadc1eb0961c23b0a"
    sha256 x86_64_linux:   "c3e2f45e057ebc00b8a825db67d9bd29396038f2beb692edcea2815c7b9d1284"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./bootstrap"
    args = %W[--prefix=#{prefix}]
    args << "LIBS=-liconv" if OS.mac?
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.rtf").write <<~'EOS'
      {\rtf1\ansi
      {\b hello} world
      }
    EOS
    expected = <<~EOS
      <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
      <html>
      <head>
      <meta http-equiv="content-type" content="text/html; charset=utf-8">
      <!-- Translation from RTF performed by UnRTF, version #{version} -->
      </head>
      <body><b>hello</b> world</body>
      </html>
    EOS
    assert_equal expected, shell_output("#{bin}/unrtf --html test.rtf")
  end
end
