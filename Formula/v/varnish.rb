class Varnish < Formula
  desc "High-performance HTTP accelerator"
  homepage "https://www.varnish-cache.org/"
  url "https://github.com/varnish/varnish/releases/download/varnish-9.0.2/varnish-9.0.2.tar.gz"
  sha256 "f3fcee6bd88bcb01a188eada0efe6fe89fb2d399a7b78c467d29c6d3752c4709"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "5271f28bd22252062f3578275790b3cec9461169e6ab8048d34c0244a34a1da8"
    sha256 arm64_sequoia: "207575c7500d3d22680160519b83840edc05b157a2a2c8ab03c9cb0f91b2c54f"
    sha256 arm64_sonoma:  "f31746c41f28947a349185ac4bcaa1cc76b4ed1cda0f97b7b54a30a4dabe2ba6"
    sha256 sonoma:        "9c5fad4e0d1a76754b5f3efea0eef158b25b319868befd82c0be7864ba69b4d6"
    sha256 arm64_linux:   "f7514f78984041cdc0801712e63fecb574399f271ab351d8da621a2f3d68883a"
    sha256 x86_64_linux:  "0ba87d23cc117f65b5bddeade0450476886bee141e9f450424207214096e4ac7"
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
