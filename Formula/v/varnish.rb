class Varnish < Formula
  desc "High-performance HTTP accelerator"
  homepage "https://www.varnish-cache.org/"
  url "https://varnish-cache.org/_downloads/varnish-7.5.0.tgz"
  mirror "https://fossies.org/linux/www/varnish-7.5.0.tgz"
  sha256 "fca61b983139e1aac61c4546d12a1a3ab9807dbb1d8314571e3148c93ff72b5d"
  license "BSD-2-Clause"

  livecheck do
    url "https://varnish-cache.org/releases/"
    regex(/href=.*?varnish[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "05ca605a315ea6a326c9abaf7037f794c58939fed838cc5078acd88f0ec8ddf6"
    sha256 arm64_ventura:  "bb8f52011862abaf26f45082b11e44455747b64fad5998de980023bfdb701a42"
    sha256 arm64_monterey: "2a1d0434bf0df77afaed7930f836c0f0247c2833c8d691f361754b8c8edd2cbb"
    sha256 sonoma:         "f99ec704f81ef63bc861fd4306681a8ac58392c182813e41e435fad35d1d37ed"
    sha256 ventura:        "bc1ab78a6465477ddf05aa268aa841ed8c352010c62a12c341d4fed79a6635d5"
    sha256 monterey:       "54ef03c825b0677c218dceb588505c79b026492f55a8ef17c076707c40756f94"
    sha256 x86_64_linux:   "5e3efd58286811d442ef30b836a17c6d46a1d10d931f7517afa56ba9deeb9cb2"
  end

  depends_on "docutils" => :build
  depends_on "graphviz" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "pcre2"

  uses_from_macos "python" => :build
  uses_from_macos "libedit"
  uses_from_macos "ncurses"

  def install
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
    timeout_tests = [
      testpath/"m00000.vtc",
      testpath/"b00047.vtc",
      testpath/"u00008.vtc",
    ]
    tests = testpath.glob("[bmu]*.vtc") - timeout_tests
    # -j: run the tests (using up to half the cores available)
    # -q: only report test failures
    # varnishtest will exit early if a test fails (use -k to continue and find all failures)
    system bin/"varnishtest", "-j", [Hardware::CPU.cores / 2, 1].max, "-q", *tests
  end
end
