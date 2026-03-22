class Varnish < Formula
  desc "High-performance HTTP accelerator"
  homepage "https://www.varnish-cache.org/"
  url "https://github.com/varnish/varnish/releases/download/varnish-9.0.0/varnish-9.0.0.tar.gz"
  sha256 "c943862cb18c430a0f8fe0688991d581593736063158ca5be76eca178aa7f149"
  license "BSD-2-Clause"

  bottle do
    sha256 arm64_tahoe:   "e50d44672c5f0519f1dec0c0c4cbf53b5107328bec67adb3f976311f10d4b401"
    sha256 arm64_sequoia: "5deb140bc414198043621ad7b440f5186869ad090171342dc978a54818beb397"
    sha256 arm64_sonoma:  "dec0bc74ff3fce0d7473b39aafa25075a5c69f8cf8b28f7da030d507d7330192"
    sha256 sonoma:        "8f9e7bb52a3fc36576dd64742c7df6e36afca0d60c677008dcfbc7a7b61f700f"
    sha256 arm64_linux:   "a3a161859af067276b101ed3cc6cd9b78c1717dcf39f8e72ff004d92e1fd6481"
    sha256 x86_64_linux:  "3560def55797a986a90850a95b54924b802ed674fc402033b09b1d3ae30aef87"
  end

  depends_on "docutils" => :build
  depends_on "graphviz" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@3"
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

    (pkgshare/"tests").install buildpath.glob("bin/vinyltest/tests/*.vtc")
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

    # test suites need libvmod_debug.so, see discussions in https://github.com/varnishcache/varnish-cache/issues/4393
    debug_tests = [
      testpath/"b00040.vtc",
      testpath/"b00070.vtc",
      testpath/"b00085.vtc",
      testpath/"b00092.vtc",
      testpath/"m00019.vtc",
      testpath/"m00021.vtc",
      testpath/"m00023.vtc",
      testpath/"m00022.vtc",
      testpath/"b00060.vtc",
      testpath/"m00025.vtc",
      testpath/"m00027.vtc",
      testpath/"m00048.vtc",
      testpath/"m00049.vtc",
      testpath/"m00054.vtc",
      testpath/"m00053.vtc",
      testpath/"m00051.vtc",
      testpath/"m00052.vtc",
      testpath/"m00059.vtc",
      testpath/"m00060.vtc",
      testpath/"m00061.vtc",
    ]
    tests = testpath.glob("[bmu]*.vtc") - timeout_tests - debug_tests
    # -j: run the tests (using up to half the cores available)
    # -q: only report test failures
    # varnishtest will exit early if a test fails (use -k to continue and find all failures)
    system bin/"varnishtest", "-j", [Hardware::CPU.cores / 2, 1].max, "-q", *tests
  end
end
