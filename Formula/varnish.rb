class Varnish < Formula
  desc "High-performance HTTP accelerator"
  homepage "https://www.varnish-cache.org/"
  url "https://varnish-cache.org/_downloads/varnish-6.6.1.tgz"
  mirror "https://fossies.org/linux/www/varnish-6.6.1.tgz"
  sha256 "ab1a6884332731f983c8dab675c636deb3883a206c8a0127a7c663af2422e628"
  license "BSD-2-Clause"

  livecheck do
    url "https://varnish-cache.org/releases/"
    regex(/href=.*?varnish[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "90395c54ed97faf31477f7779088f6addd17d0c8b7f22b78437ecebc3a529031"
    sha256 big_sur:       "360fe3fe1488fe89e7dc6dec91d95bdadf0f863d5317237d09578e3acd0f7d2a"
    sha256 catalina:      "26fe8fdfc6c09a1568809497e117a243f28edb48334ee2ea2a523f72f89b8a48"
    sha256 mojave:        "2d480e00bc3bea3a4fbeae03947d58a6d7eea6bb4dae31f78bf14767a49643e2"
  end

  depends_on "docutils" => :build
  depends_on "graphviz" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "sphinx-doc" => :build
  depends_on "pcre"

  def install
    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}"
    system "make", "install"
    (etc/"varnish").install "etc/example.vcl" => "default.vcl"
    (var/"varnish").mkpath
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
  end
end
