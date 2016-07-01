class Unrtf < Formula
  desc "RTF to other formats converter"
  homepage "https://www.gnu.org/software/unrtf/"
  url "https://ftpmirror.gnu.org/unrtf/unrtf-0.21.9.tar.gz"
  mirror "https://ftp.gnu.org/gnu/unrtf/unrtf-0.21.9.tar.gz"
  sha256 "22a37826f96d754e335fb69f8036c068c00dd01ee9edd9461a36df0085fb8ddd"

  head "http://hg.savannah.gnu.org/hgweb/unrtf/", :using => :hg

  bottle do
    sha256 "2d658e54c0f66ae90764c8588fa7181c68d69d505336747b9bd5e496ba7b99d6" => :el_capitan
    sha256 "42737f31a7ea06592c2ad22a48f0e2537c0cd025129870399bd4f0fbe7362a98" => :yosemite
    sha256 "852bd896c8537489400e646ed41f2876079e124203e493cfc1e2d7f51d024726" => :mavericks
    sha256 "7e680da7a4c4da9ed3b21f04e5125721cf506cc9579a2e95b4635078b0606cb2" => :mountain_lion
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build

  def install
    system "./bootstrap"
    system "./configure", "LIBS=-liconv", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.rtf").write <<-'EOS'.undent
      {\rtf1\ansi
      {\b hello} world
      }
    EOS
    expected = <<-EOS.undent
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
