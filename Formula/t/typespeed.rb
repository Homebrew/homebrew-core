class Typespeed < Formula
  desc "Zap words flying across the screen by typing them correctly"
  homepage "https://typespeed.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/typespeed/typespeed/0.6.5/typespeed-0.6.5.tar.gz"
  sha256 "5c860385ceed8a60f13217cc0192c4c2b4705c3e80f9866f7d72ff306eb72961"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "0180b1eba9c871f2ae91394a54bc99f92e5c48db780f1ad601bbfd2691bf4e5a"
    sha256 arm64_sequoia:  "ab447d0e1c0d2482ef500191eb296b9da4a5d49735d9326e5c738cb496aaaa43"
    sha256 arm64_sonoma:   "5515f9db04d81a28229879b3c60150bde9f9d22d77c95a124f4d862d82645712"
    sha256 arm64_ventura:  "5b61f01011a8cd0315d07703f8efcba7fc009f9efa4a4c7a75254a1ac239e681"
    sha256 arm64_monterey: "f34485cb16d4e55ec320c2ed3a5a0f5c681a73ef7950c8f8c609b7b93a8a34e8"
    sha256 arm64_big_sur:  "bf2143006f2dbbb230b3c899a77fc98c1a056316fc957f195a5fb4b27c388947"
    sha256 sonoma:         "5c5ee2bc8feb9d58b2e67e43d5093796750ff6e7d45351a0f0161027b067b9ae"
    sha256 ventura:        "346b2433e18fde5989536ed95707edf90baa445b61edfcc40f8308edccbfece5"
    sha256 monterey:       "f369e235804129a758d84d47415d28bea243b3579cd96bce8a3163b44739eab1"
    sha256 big_sur:        "a1624c4d927fda389aceec074f743e73bd10417059764d480141a88fab23bb82"
    sha256 catalina:       "cff9da11f7441f1ff4db7cbfa57f0711ff0bbe08a80ee7067021c619bc01cb06"
    sha256 arm64_linux:    "b77850229d406c13937f40c43c0cbb4888dff463edab2a4ef0f528ae0312ad78"
    sha256 x86_64_linux:   "4fcef57ff481d6947275a5b93e1489379a2ba7d1938d9de031fddd4bc4199f1d"
  end

  uses_from_macos "ncurses"

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # multiple definition of `rules'; typespeed-file.o:(.bss+0x2050): first defined here
    # multiple definition of `words'; typespeed-file.o:(.bss+0x30): first defined here
    # multiple definition of `opt'; typespeed-file.o:(.bss+0x0): first defined here
    # multiple definition of `now'; typespeed-file.o:(.bss+0x30b0): first defined here
    ENV.append_to_cflags "-fcommon" if OS.linux?

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    # Fix the hardcoded gcc.
    inreplace "src/Makefile.in", "gcc", ENV.cc
    inreplace "testsuite/Makefile.in", "gcc", ENV.cc
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end
end
