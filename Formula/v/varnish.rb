class Varnish < Formula
  desc "High-performance HTTP accelerator"
  homepage "https://www.varnish-cache.org/"
  url "https://varnish-cache.org/_downloads/varnish-7.7.3.tgz"
  mirror "https://fossies.org/linux/www/varnish-7.7.3.tgz"
  sha256 "e96eeafc4cfe2a558ed2fb54f1e22be3a3d995f46f8c00da545d583aaef80236"
  license "BSD-2-Clause"

  livecheck do
    url "https://varnish-cache.org/releases/"
    regex(/href=.*?varnish[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "22a9746eec231a7c0f18b5687805d90bbed988aa2159441ac4e7e2675ee93c06"
    sha256 arm64_sequoia: "ed2e745c07dde91d8b7db4521187aafd7cf598dd9cc84d7642f7ab1bd408dec5"
    sha256 arm64_sonoma:  "bf27e2caf53c14f1cb2bbab899b9eda77025f3246d99faa968548e91918c2e66"
    sha256 arm64_ventura: "12082dc9354253a4e2641bc07383427d158ffc976bbbea65e1a23a53c186d4ca"
    sha256 sonoma:        "d90ccf06cfcc1e990666cdc22a5d042d8bd3d4d4feb800b3fc707c223d3fa6fd"
    sha256 ventura:       "976d770d0de09defe83d366aae79240f27a68c044735bdc8e89ac60aad4a6b03"
    sha256 arm64_linux:   "5ace8a30ad386158d8c61898055ac6e75e3b438c2e16e97306d10354fdd9eab6"
    sha256 x86_64_linux:  "6f3f69bab6e9cddeec6b69105fb6fecefc93e72f86256dcc36a6c3bb2a94408c"
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
