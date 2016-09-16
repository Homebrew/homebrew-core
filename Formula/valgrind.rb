class Valgrind < Formula
  desc "Dynamic analysis tools (memory, debug, profiling)"
  homepage "http://www.valgrind.org/"
  revision 1
  head "svn://svn.valgrind.org/valgrind/trunk"

  stable do
    url "http://valgrind.org/downloads/valgrind-3.11.0.tar.bz2"
    sha256 "6c396271a8c1ddd5a6fb9abe714ea1e8a86fce85b30ab26b4266aeb4c2413b42"

    # Fix tst->os_state.pthread - magic_delta assertion failure on OSX 10.11
    # https://bugs.kde.org/show_bug.cgi?id=354883
    # https://github.com/liquid-mirror/valgrind/commit/8f0b10fdc795f6011c17a7d80a0d65c36fcb8619.diff
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/cc0e461/valgrind/10.11_assertion.diff"
      sha256 "c4b73d50069f59ad2bcbddd5934b7068318bb2ba31f702ca21fb42d558addff4"
    end

    # Add support for Xcode 8 (svn r15949)
    # https://bugs.kde.org/show_bug.cgi?id=366138#c5
    # https://github.com/liquid-mirror/valgrind/commit/16ff0e684bd44acc2e6d3a369876fe0c331e641d
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/b42540f/valgrind/xcode-8.diff"
      sha256 "1191a728fa6df5de3520be57238a265815156d48062cdd12d2d6517fbdc8443f"
    end
  end

  bottle do
    sha256 "135876549d56520b45c659ba10016da512ce2e64e133484e9d3f65d63af596a0" => :el_capitan
    sha256 "59ed8706211ac8a82b4025e5ea489061822503e8cae3ec37390fc59fa8990e38" => :yosemite
    sha256 "13b4586d3781bc50bcc2cd14ed05d19333ef85b91ef4b2b21b4c1438dba163b5" => :mavericks
  end

  # These should normally be head-only deps, but we're patching stable's
  # configure.ac for Xcode 8 compatibility, so we always have to run
  # autogen.sh. Restore head-only status when the next stable release comes
  # out.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on :macos => :snow_leopard
  # See currently supported platforms: http://valgrind.org/info/platforms.html
  # Also dev comment: https://bugs.kde.org/show_bug.cgi?id=366138#c5
  depends_on MaximumMacOSRequirement => :el_capitan

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

    # Always run autogen.sh due to us patching stable's configure.ac.
    # Restore "if build.head?" when the next stable release comes out.
    system "./autogen.sh"

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
