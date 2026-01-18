class Sc68 < Formula
  desc "Play music originally designed for Atari ST and Amiga computers"
  homepage "https://sc68.atari.org/project.html"
  url "https://downloads.sourceforge.net/project/sc68/sc68/2.2.1/sc68-2.2.1.tar.gz"
  sha256 "d7371f0f406dc925debf50f64df1f0700e1d29a8502bb170883fc41cc733265f"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/sc68[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "4bd1deeac4b3f633c76cc844a611217c4bd96ed9a9e1ae2376cd280f0a11842c"
    sha256 arm64_sequoia:  "530da22ced84ec1181ddf6887028d6a4e9fa955446a492c039e5c807d6f2ec82"
    sha256 arm64_sonoma:   "f6c0c19ce245cb76ed53a1e9d017eb6b598ac1834f5c7ff215978147498be18e"
    sha256 arm64_ventura:  "f30cf9999c9d98d9e0c2ecee6b0af0f5f550391ecfbfa51d8f5139dce0aaa0c6"
    sha256 arm64_monterey: "f0f1ad019d6ae62b500fe9395c6e2cc9fe902532c13a2ffef0001763da251433"
    sha256 arm64_big_sur:  "88997849149a628f35a9e44e3abe898c7db9458a796cc61275abfd26923de1bd"
    sha256 sonoma:         "62a7348263be1d268e4682a2690354bf954d5ae71c3d702c6f50b7740ad502f1"
    sha256 ventura:        "f167bb16c498a40a89d35c12447acd1e25ea7a5581b8de6acd483a7384ac41c1"
    sha256 monterey:       "958f47e1b57574ba4ea608fa26a50af67feef92bba51d7e9b598ef0567fb4feb"
    sha256 big_sur:        "d5ac6383a3b1f82707b9a981ca02ce6dee57cdc096adb16dbf044ef5c5a051c9"
    sha256 catalina:       "1d06595617862cdb67d49f8bc8389e7e6cb4bd6f6ac81adf20969c68bbe80434"
    sha256 arm64_linux:    "ce25e34fecfd668e1f6fa0ef0d924b96df389c43c5428e386b54a5411c7f0d24"
    sha256 x86_64_linux:   "1876d7c98fac9c5a36824c13141354e0cbce33508f155741d8430182d7fd6104"
  end

  head do
    url "https://svn.code.sf.net/p/sc68/code/"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkgconf" => :build
  end

  uses_from_macos "zlib"

  on_linux do
    depends_on "readline"
  end

  def install
    if build.head?
      system "tools/svn-bootstrap.sh"
    else
      inreplace "configure", "-flat_namespace -undefined suppress", "-undefined dynamic_lookup"
      # Workaround for newer Clang
      odie "Try to remove workaround for Xcode 16 Clang!" if version > "2.2.1"
      ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500
    end

    args = ["--mandir=#{man}", "--infodir=#{info}"]
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    # SC68 ships with a sample module; test attempts to print its metadata
    system bin/"info68", pkgshare/"Sample/About-Intro.sc68", "-C", ": ", "-N", "-L"
  end
end
