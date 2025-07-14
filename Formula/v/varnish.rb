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
    rebuild 1
    sha256 arm64_sequoia: "fd568d267ee9b5844a3c2b0233c12a51e8a00022b031cdfb569988aa92fc1f73"
    sha256 arm64_sonoma:  "4223322b623694e089924b568cd1fae3e9b67c31c1faead969abd8ee323a7825"
    sha256 arm64_ventura: "322c722503c07ddccb64054f88cb9e2f526dd02aee8069361f36dc7f7b88ec8a"
    sha256 sonoma:        "88831645eae4467af0e537c506dcf4cdd99078d93cfa9d2fe0c01329c27e1714"
    sha256 ventura:       "0181d254c66b3b6676b387770bcd38ce6899aeb5d80a68539cb3a319c2bee5ca"
    sha256 arm64_linux:   "9551bad52ea1d85bd154180a46b38f95d806b3d50b85d74140be235b946607d3"
    sha256 x86_64_linux:  "dc1f0dbc8fbf3683d83c6e2e324d519b9b30daf7c70744340ff91ef0427aaa9d"
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
         "127.0.0.1:2000", "-a", "127.0.0.1:8080", "-F"]
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
