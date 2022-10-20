class Varnish < Formula
  desc "High-performance HTTP accelerator"
  homepage "https://www.varnish-cache.org/"
  url "https://varnish-cache.org/_downloads/varnish-7.2.0.tgz"
  mirror "https://fossies.org/linux/www/varnish-7.2.0.tgz"
  sha256 "1da8a97ed5f7b7d4d5e04fc5c96fc9a85cb3a20d076eba2b18951f4b306c9686"
  license "BSD-2-Clause"

  livecheck do
    url "https://varnish-cache.org/releases/"
    regex(/href=.*?varnish[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "c23279e2aa75bc420476c672c62e0293fffed8b9592348f3ee785a0c1ad54cb4"
    sha256 arm64_big_sur:  "f774aa8ae9013a8385798eb20d60917051809288b032bb88b7cc2debde0d6aab"
    sha256 monterey:       "bdca7e45a4a491f735b5c9be0802235af658e7bf1a87190cb008d284a1cd7f0a"
    sha256 big_sur:        "d057b99161f720e2b04b89c71f33761a7307d411b3542eb22a63c2d3008fda45"
    sha256 catalina:       "9b2f43793432c39a0b3891560935fcca08e729e080d4deeb7a08f96ee17f4211"
    sha256 x86_64_linux:   "c5e06bbb449ea6196cc702fd91aa2d0a5e5b3fc1eb93eb90a527e6e38a87d4cf"
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
