class Valgrind < Formula
  desc "Dynamic analysis tools (memory, debug, profiling)"
  homepage "http://www.valgrind.org/"

  stable do
    url "https://sourceware.org/pub/valgrind/valgrind-3.13.0.tar.bz2"
    mirror "https://dl.bintray.com/homebrew/mirror/valgrind-3.13.0.tar.bz2"
    sha256 "d76680ef03f00cd5e970bbdcd4e57fb1f6df7d2e2c071635ef2be74790190c3b"

    # valgrind does not yet support High Sierra
    # https://bugs.kde.org/show_bug.cgi?id=383811
    depends_on MaximumMacOSRequirement => :sierra

    # Fix build on 10.12 with Xcode 9
    # Upstream commit from 24 Sep 2017 "Support all Apple clang/LLVM 5.1+"
    # See https://sourceware.org/git/?p=valgrind.git;a=commit;h=27e1503bc7bd767f3a98824176558beaa5a7c1d5
    if DevelopmentTools.clang_build_version >= 900
      patch :p0 do
        url "https://raw.githubusercontent.com/Homebrew/formula-patches/b3915f6/valgrind/sierra-xcode9.diff"
        sha256 "156ea88edd2116dd006d6e5550578af3f2a2e3923818a238b9166cd02e327432"
      end
    end
  end

  bottle do
    sha256 "1ae24d4988d010b407bb344c953dd8a7696876a3c2793f2548648be4cfc61db2" => :sierra
    sha256 "8dcc652676c3ec2f1fd3dfc710298b4da0985b1a056f86c429e68b5b8bcf74a6" => :el_capitan
    sha256 "02f118896232618cb6319e22f21cea21d29f8985be4807547bb49bc397307730" => :yosemite
  end

  head do
    url "https://sourceware.org/git/valgrind.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Valgrind needs vcpreload_core-*-darwin.so to have execute permissions.
  # See #2150 for more information.
  skip_clean "lib/valgrind"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    if MacOS.prefer_64_bit?
      args << "--enable-only64bit" << "--build=amd64-darwin"
    else
      args << "--enable-only32bit"
    end

    system "./autogen.sh" if build.head?

    # Look for headers in the SDK on Xcode-only systems: https://bugs.kde.org/show_bug.cgi?id=295084
    unless MacOS::CLT.installed?
      inreplace "coregrind/Makefile.in", %r{(\s)(?=/usr/include/mach/)}, '\1'+MacOS.sdk_path.to_s
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/valgrind", "ls", "-l"
  end
end
