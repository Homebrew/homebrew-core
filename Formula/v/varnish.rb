class Varnish < Formula
  desc "High-performance HTTP accelerator"
  homepage "https://www.varnish-cache.org/"
  url "https://github.com/varnish/varnish/releases/download/varnish-9.0.3/varnish-9.0.3.tar.gz"
  sha256 "2aac11dd95329b0cea148d478168b3ccc6fe45fab38160c440159386403b69fd"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "4b155b95d54d1219d675c68e74678e74a41832c38f5599520ed1b8e8a5c174d3"
    sha256 arm64_sequoia: "e2777c2eebc9ebfa75ac21b38e97f9849cf56d1ba0dc094539c92a6342e8f386"
    sha256 arm64_sonoma:  "39920fb27511634853cf75b455acd11fd758c0eb9f9d2581a38b18fbb3010459"
    sha256 sonoma:        "60428bf227dcffc1ec13a1e5c98abf1147b1f0eca4a5a62ae6ee6dfd501a5066"
    sha256 arm64_linux:   "cd6a933aefd04c2160203f85113a6d6698b967aa2a1d1ebdeed069d20c0ebd55"
    sha256 x86_64_linux:  "8a4241f6aea15847b0bbbb4bc0b76ad9240d2e3259c52105727406da9cc92c15"
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
