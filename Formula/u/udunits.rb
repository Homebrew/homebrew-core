class Udunits < Formula
  desc "Unidata unit conversion library"
  homepage "https://docs.unidata.ucar.edu/udunits/current/"
  url "https://downloads.unidata.ucar.edu/udunits/2.2.28/udunits-2.2.28.tar.gz"
  sha256 "590baec83161a3fd62c00efa66f6113cec8a7c461e3f61a5182167e0cc5d579e"
  license "UCAR"

  livecheck do
    url "https://downloads.unidata.ucar.edu/udunits/release_info.json"
    strategy :json do |json|
      json["releases"]&.map { |item| item["version"] }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "9be11e8aa15c3a8eaf65ca066808eacbfda46e627f6ab4bd42bc6778b52c3984"
    sha256 arm64_sequoia:  "8ba9d3ce2f87072bd50d40063a6db63a456ec9a934d381002d1c31587c0e10b1"
    sha256 arm64_sonoma:   "bb3b99a3627d9008b70648de70aee2014444eebc0eac4ad50d2cec00c4260a62"
    sha256 arm64_ventura:  "c6f54e9f07ec6617aeee1bd95a6ebd444e5b72adb9c3268b9fdb68cd443c26f6"
    sha256 arm64_monterey: "64af7e42ad61c45d6f1790d747c9e3d8bbd8634a86fc51961646b31a16f64edf"
    sha256 arm64_big_sur:  "d7abb17bec04dc4aede1c62e24766a4f31c6d4c4cc5f1716fcb56f1da06b0492"
    sha256 sonoma:         "da48653db9f58cce8bcb98eb2bbf8a8949d8a90114c20ae3b63900f1abe8800e"
    sha256 ventura:        "05ba4dddcb5941e0a0af12b1064403e144577e4910c851a2e8ecb13d1faa5b20"
    sha256 monterey:       "ed2147b73e154d445d1959b871e956975bc2ed2d33757d9ed57df1114af2222c"
    sha256 big_sur:        "cb3a237ce5aa71c094ece2c9a7ba3199238d8facf053760a5f29ebec93f29e53"
    sha256 catalina:       "5787ba730b9969468621db38503a036de75aea0a8e62cbd253e9c73262355419"
    sha256 arm64_linux:    "9f5ace99f37c2ada5a443b740687abd53823d454265843bd9f029a7cbe49bea6"
    sha256 x86_64_linux:   "9df6142349c78d0ebb0922ea53c48f702ca83cf223513437022086ee332c22a8"
  end

  head do
    url "https://github.com/Unidata/UDUNITS-2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "expat"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match(/1 kg = 1000 g/, shell_output("#{bin}/udunits2 -H kg -W g"))
  end
end
