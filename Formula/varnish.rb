class Varnish < Formula
  desc "High-performance HTTP accelerator"
  homepage "https://www.varnish-cache.org/"
  url "https://varnish-cache.org/_downloads/varnish-7.0.0.tgz"
  mirror "https://fossies.org/linux/www/varnish-7.0.0.tgz"
  sha256 "8c7a5c0b1f36bc70bcbc9a48830835249e895fb8951f0363110952148cbae087"
  license "BSD-2-Clause"

  livecheck do
    url "https://varnish-cache.org/releases/"
    regex(/href=.*?varnish[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "f9c517f21a3f138c278677921e69f235c6d4c47a058e9f560c4bbbd4afcb57af"
    sha256 big_sur:       "84a3945f0b46dd350ac857fbaa60b624e7e94f14975278db5aa6f7d0a9f2b55c"
    sha256 catalina:      "2250a294b46b4371d881bc47ea82b933d6ac422eceb93b7fef53ed6f5105f2b7"
    sha256 mojave:        "740bef57e40926315783b67ac0d8bef045f0a69c6130f7f86fcb9691ec5119be"
  end

  depends_on "docutils" => :build
  depends_on "graphviz" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "sphinx-doc" => :build
  depends_on "pcre2"

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
