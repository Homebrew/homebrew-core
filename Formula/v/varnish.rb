class Varnish < Formula
  desc "High-performance HTTP accelerator"
  homepage "https://www.varnish-cache.org/"
  url "https://varnish-cache.org/_downloads/varnish-7.4.1.tgz"
  mirror "https://fossies.org/linux/www/varnish-7.4.1.tgz"
  sha256 "874d837aaf49b8f2718cb60b8c8c7900e9ea10c264f218c88cd672d596f4b89f"
  license "BSD-2-Clause"

  livecheck do
    url "https://varnish-cache.org/releases/"
    regex(/href=.*?varnish[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "baa3d9b974e396658f8d4afbbc2fb616855440ae9e45584be3c0bef4880cf0a7"
    sha256 arm64_ventura:  "a5e1cf1c5e87ce6437207125acaa7a0687ea0f267c4562399090efcb563edcb0"
    sha256 arm64_monterey: "410ab72c7543e5ef5345b75bff89c0f6afc451303693fd1cc56e5c60c515c2b7"
    sha256 arm64_big_sur:  "de9393b3f2895e5d8b3c6f647e136073a7f2b57858f272987d116f0055e4ef07"
    sha256 sonoma:         "40502e21422208af128171163215cf3b5fd8e7cc61a8d1fe324392d319479beb"
    sha256 ventura:        "40a9a68b2572b1c4c033ea7e2023578211d53ff85aa022ea90643f91d7c52186"
    sha256 monterey:       "84213e33e6ab7068af70c6bff3592822d569eb61a1322c0b33a7fd048f07a76d"
    sha256 big_sur:        "e457a51ea02ff7b3c00b36c536507742d3995a7cfa2aa1f81105d20d0e5c60f6"
    sha256 x86_64_linux:   "f8827726b9f6936bf4c3d7ca70027be86433c90a22fa20cbd55073fe99ee4cd6"
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
