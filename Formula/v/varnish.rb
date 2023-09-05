class Varnish < Formula
  desc "High-performance HTTP accelerator"
  homepage "https://www.varnish-cache.org/"
  url "https://varnish-cache.org/_downloads/varnish-7.3.0.tgz"
  mirror "https://fossies.org/linux/www/varnish-7.3.0.tgz"
  sha256 "e2dbbb0ec270a90647c386866e6e226993aed46e48de751a72bb819737f14ae7"
  license "BSD-2-Clause"

  livecheck do
    url "https://varnish-cache.org/releases/"
    regex(/href=.*?varnish[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "2dd251edcc1036789e19ada129c56b02cda4d35f569c37b137f893b013746808"
    sha256 arm64_monterey: "92229d29cd0fff3f51b9bb975062138ce4e69f2c877e47a5d3b0909e92103915"
    sha256 arm64_big_sur:  "898cca625a7d3ed0b73c3c0696323cd8dd231358678c2cb90f500c9d2e97844e"
    sha256 ventura:        "432fac72abe49eae6a92277fad47b611371b983709b981d36991cc4df2dea881"
    sha256 monterey:       "4fcc3cf2b1fd09a29e65a7ba9f2f30b0ab64585f23a8a49ff01a2d13f46d4c4b"
    sha256 big_sur:        "02013a9904aeee2c320e9595668569bba705ef415225c1c2001579ed19315017"
    sha256 x86_64_linux:   "5f27365c143163e3c91f73a23c325694b459779e8e74db9e4bb9695ca7a8067b"
  end

  depends_on "docutils" => :build
  depends_on "graphviz" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "sphinx-doc" => :build
  depends_on "pcre2"

  uses_from_macos "libedit"
  uses_from_macos "ncurses"

  def install
    ENV["PYTHON"] = Formula["python@3.11"].opt_bin/"python3.11"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}"

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
    tests = testpath.glob("[bmu]*.vtc") - [testpath/"m00000.vtc"]
    # -j: run the tests (using up to half the cores available)
    # -q: only report test failures
    # varnishtest will exit early if a test fails (use -k to continue and find all failures)
    system bin/"varnishtest", "-j", [Hardware::CPU.cores / 2, 1].max, "-q", *tests
  end
end
