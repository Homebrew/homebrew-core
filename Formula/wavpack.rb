class Wavpack < Formula
  desc "Hybrid lossless audio compression"
  homepage "http://www.wavpack.com/"
  url "http://www.wavpack.com/wavpack-4.80.0.tar.bz2"
  sha256 "79182ea75f7bd1ca931ed230062b435fde4a4c2e0dbcad048007bd1ef1e66be9"

  bottle do
    cellar :any
    sha256 "5615534df0be36fbafc1c7b3bc8c6ff573c45f6386b5579ca487113c09a56763" => :sierra
    sha256 "09cf095c693a86fc3dc0d0c6f07c11d0987c68b885c92b4f0755cf16b86ea315" => :el_capitan
    sha256 "24b04bf3efb68226dad7fecd7dec17cde6aafc39ba7ed24ea5730db02bb600e8" => :yosemite
    sha256 "1b334fd19ec16882bbd5170c5d9d5abbb5e8dee6f78965e572d909f198dac5ef" => :mavericks
  end

  head do
    url "https://github.com/dbry/WavPack.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  def install
    args = %W[--prefix=#{prefix} --disable-dependency-tracking]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  test do
    system bin/"wavpack", test_fixtures("test.wav"), "-o", testpath/"test.wv"
    File.exist? "test.wv"
  end
end
