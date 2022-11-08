class Varnish < Formula
  desc "High-performance HTTP accelerator"
  homepage "https://www.varnish-cache.org/"
  url "https://varnish-cache.org/_downloads/varnish-7.2.1.tgz"
  mirror "https://fossies.org/linux/www/varnish-7.2.1.tgz"
  sha256 "4d937d1720a8ec19c533f972d9303a1c9889b7bfca7437893ae5c27cf204a940"
  license "BSD-2-Clause"

  livecheck do
    url "https://varnish-cache.org/releases/"
    regex(/href=.*?varnish[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "97837ceaffdb8bd8bfb4eb8bb6ca2ecaffa0330d9f3230118cd80beb64a69f3c"
    sha256 arm64_monterey: "54d9b377ca097b2b52a6587b008861942980304d498f1ca763c381eadda84dde"
    sha256 arm64_big_sur:  "52abe334b03a84878db5e12e656fdee57bf96d0850e16acf5c41de22e20d3a42"
    sha256 monterey:       "1f5136cf626233f818e8b360903681fb6ac26da594eebc22464f3645e15676af"
    sha256 big_sur:        "1e898c2342fc114e4d125da13affff0abe826f88b83d130da9b93e9decfdb9dc"
    sha256 catalina:       "71676992efeb6f6bdc5bbd9dee205e3b0e752cb5b38032586d35043ac007361d"
    sha256 x86_64_linux:   "64855ed4ce7f02bcd01eccc9dfdd0977239a39023349f7b83b91ffc5cb15d53c"
  end

  depends_on "docutils" => :build
  depends_on "graphviz" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "sphinx-doc" => :build
  depends_on "pcre2"

  uses_from_macos "libedit"
  uses_from_macos "ncurses"

  def install
    ENV["PYTHON"] = Formula["python@3.10"].opt_bin/"python3.10"

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
