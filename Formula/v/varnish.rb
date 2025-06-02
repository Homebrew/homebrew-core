class Varnish < Formula
  desc "High-performance HTTP accelerator"
  homepage "https://www.varnish-cache.org/"
  url "https://varnish-cache.org/_downloads/varnish-7.7.1.tgz"
  mirror "https://fossies.org/linux/www/varnish-7.7.1.tgz"
  sha256 "4c06c5c99680a429b72934f9fd513963f7e1ba8553b33ca7ec12c85a5c2b751a"
  license "BSD-2-Clause"

  livecheck do
    url "https://varnish-cache.org/releases/"
    regex(/href=.*?varnish[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "fb5cbe8656ede605c0237b5547fd8597cc28f6610f7c6a0055eb4c1abce170f8"
    sha256 arm64_sonoma:  "ffb66142d7b11573ae3678aeabb73a3562f4d88d1ed685275ec6bd2a455c1a96"
    sha256 arm64_ventura: "83d569419f98c2f552bf12e7976933c06951923659c0c5f7e78cabd15145f802"
    sha256 sonoma:        "be72b7f7e58cb4978f546ee7fef88b54e524217a4626712872933103a52c70f4"
    sha256 ventura:       "d098652ecc801d17d010faf7e18ce1767773bd41c2b8fd8562657279f9ba506f"
    sha256 arm64_linux:   "87f26a2116f5a9345eb1bdd23bf3573d27daafdfb93f5a160d1a32fc8cbed8bc"
    sha256 x86_64_linux:  "58c14e678d32e15e03fb6f88bf4cc886244dd7e8d47521e57a97bce1c3c68d9f"
  end

  depends_on "docutils" => :build
  depends_on "graphviz" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "pcre2"

  uses_from_macos "python" => :build
  uses_from_macos "libedit"
  uses_from_macos "ncurses"

  # macos compatibility patches, upstream pr ref, https://github.com/varnishcache/varnish-cache/pull/4339
  patch do
    url "https://github.com/varnishcache/varnish-cache/commit/3e679cd0aa093f7b1c426857d24a88d3db747f24.patch?full_index=1"
    sha256 "677881ed5cd0eda2e1aa799ca54601b44a96675763233966c4d101b83ccdfd73"
  end
  patch do
    url "https://github.com/varnishcache/varnish-cache/commit/acbb1056896f6cf4115cc2a6947c9dbd8003176e.patch?full_index=1"
    sha256 "915c5b560aa473ed139016b40c9e6c8a0a4cce138dd1126a63e75b58d8345e73"
  end

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
