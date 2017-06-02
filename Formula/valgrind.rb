class Valgrind < Formula
  desc "Dynamic analysis tools (memory, debug, profiling)"
  homepage "http://www.valgrind.org/"

  stable do
    url "http://valgrind.org/downloads/valgrind-3.12.0.tar.bz2"
    sha256 "67ca4395b2527247780f36148b084f5743a68ab0c850cb43e4a5b4b012cf76a1"

    # SVN r16103:
    # "bzero is non-POSIX (deprecated), accordingly __bzero template required
    # for all macOS versions. n-i-bz."
    #
    # Fixes build on macOS 10.12 (at least). Otherwise we would get undefined
    # symbols error for __bzero.
    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/54d59bf/valgrind/bzero.diff"
      sha256 "48de4054dba20c27ef6089d3ea7832e48dcbbb5368ac4316394b8be55ffe93a2"
    end
  end

  bottle do
    sha256 "ab3ef2be621bc6b0619d2a87a263d8d7a99056101305b3f4116d4c98049bd782" => :el_capitan
    sha256 "641cd92b8fa21863db3fadc5be6054477933eba9d2fcee6b54ed797ae5b01f63" => :yosemite
  end

  head do
    url "svn://svn.valgrind.org/valgrind/trunk"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # https://bugs.kde.org/show_bug.cgi?id=365327#c2
  # https://github.com/Homebrew/homebrew-core/pull/6231#issuecomment-255779374
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
