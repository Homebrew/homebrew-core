class Varnish < Formula
  desc "High-performance HTTP accelerator"
  homepage "https://www.varnish-cache.org/"
  url "https://varnish-cache.org/_downloads/varnish-7.0.0.tgz"
  mirror "https://fossies.org/linux/www/varnish-7.0.0.tgz"
  sha256 "8c7a5c0b1f36bc70bcbc9a48830835249e895fb8951f0363110952148cbae087"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url "https://varnish-cache.org/releases/"
    regex(/href=.*?varnish[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "f3430a0d15dcf0f3c49901d836df00802e07e49e50cf843cc60797932105aef6"
    sha256 big_sur:       "04dab009e3b61c2339cf91324869ac28d48643f24bfb6e7de35fdb714eacc36a"
    sha256 catalina:      "04a13eafe484743944404dbbe132ba7148bb1a4a44f30a4d6df55e94d709dd89"
  end

  depends_on "docutils" => :build
  depends_on "graphviz" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "sphinx-doc" => :build
  depends_on "pcre2"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}"

    # flags to set the paths used by varnishd to load VMODs and VCL,
    # pointing to the ${HOMEBREW_PREFIX}/ shared structure so other packages
    # can install VMODs and VCL.
    ENV.append_to_cflags "-DVARNISH_VMOD_DIR='\"#{HOMEBREW_PREFIX}/lib/varnish/vmods\"'"
    ENV.append_to_cflags "-DVARNISH_VCL_DIR='\"#{pkgetc}:#{HOMEBREW_PREFIX}/share/varnish/vcl\"'"

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
