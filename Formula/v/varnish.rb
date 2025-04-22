class Varnish < Formula
  desc "High-performance HTTP accelerator"
  homepage "https://www.varnish-cache.org/"
  url "https://varnish-cache.org/_downloads/varnish-7.6.1.tgz"
  mirror "https://fossies.org/linux/www/varnish-7.6.1.tgz"
  sha256 "5a9bb5a149ff27867b54a66ce16d2a4b93edffa5473cb87c9c71f7699cf845ba"
  license "BSD-2-Clause"

  livecheck do
    url "https://varnish-cache.org/releases/"
    regex(/href=.*?varnish[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "c27410d2620eb90cdd55fe2d2f2cb9263e50b7e38f1657ed829933b2ba42d7dd"
    sha256 arm64_sonoma:  "dca58a2dd40ff2cd995d8ca52be858a63656a37c2098dd676ede5d2fb8ef5fc1"
    sha256 arm64_ventura: "63ce70bd5ed1b4c5c6fb069732f9619cdacc43d664fe20e6ff036e8a2ada733a"
    sha256 sonoma:        "bc34ed9be333dbdc5459f969058a42808385e76e3b2ae62bb2cee111b970ebe4"
    sha256 ventura:       "f67e4e5eb341516ad0229efe39a4012a55e840fe4f38befc9e153baabfae757e"
    sha256 arm64_linux:   "223fe086adcc8058bb06ea141b750201fb1460c235adca0969cf84f8f68e51c0"
    sha256 x86_64_linux:  "edb61c2b757d063387fcb8de36074a1dbfcec2cbe7e0637d0e9cf0966c988109"
  end

  depends_on "docutils" => :build
  depends_on "graphviz" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "pcre2"

  uses_from_macos "python" => :build
  uses_from_macos "libedit"
  uses_from_macos "ncurses"

  def install
    system "./configure", "--localstatedir=#{var}", *std_configure_args

    # flags to set the paths used by varnishd to load VMODs and VCL,
    # pointing to the ${HOMEBREW_PREFIX}/ shared structure so other packages
    # can install VMODs and VCL.
    ENV.append_to_cflags "-DVARNISH_VMOD_DIR='\"#{HOMEBREW_PREFIX}/lib/varnish/vmods\"'"
    ENV.append_to_cflags "-DVARNISH_VCL_DIR='\"#{pkgetc}:#{HOMEBREW_PREFIX}/share/varnish/vcl\"'"

    # Fix missing pthread symbols on Linux
    ENV.append_to_cflags "-pthread" if OS.linux?

    system "make", "install", "CFLAGS=#{ENV.cflags}"

    (etc/"varnish").install "etc/example.vcl" => "default.vcl"
    (var/"varnish").mkpath

    (pkgshare/"tests").install buildpath.glob("bin/varnishtest/tests/*.vtc")
    (pkgshare/"tests/vmod").install buildpath.glob("vmod/tests/*.vtc")
  end

  service do
    run [opt_sbin/"varnishd", "-n", var/"varnish", "-f", etc/"varnish/default.vcl", "-s", "malloc,1G", "-T",
         "127.0.0.1:2000", "-a", "0.0.0.0:8080", "-F"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"varnish/varnish.log"
    error_log_path var/"varnish/varnish.log"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/varnishd -V 2>&1")

    # run a subset of the varnishtest tests:
    # - b*.vtc (basic functionality)
    # - m*.vtc (VMOD modules, including loading), but skipping m00000.vtc which is known to fail
    #   but is "nothing of concern" (see varnishcache/varnish-cache#3710)
    # - u*.vtc (utilities and background processes)
    testpath = pkgshare/"tests"
    timeout_tests = [
      testpath/"m00000.vtc",
      testpath/"b00047.vtc",
      testpath/"b00084.vtc",
      testpath/"b00086.vtc",
      testpath/"u00008.vtc",
    ]
    tests = testpath.glob("[bmu]*.vtc") - timeout_tests
    # -j: run the tests (using up to half the cores available)
    # -q: only report test failures
    # varnishtest will exit early if a test fails (use -k to continue and find all failures)
    system bin/"varnishtest", "-j", [Hardware::CPU.cores / 2, 1].max, "-q", *tests
  end
end
