class Tinyproxy < Formula
  desc "HTTP/HTTPS proxy for POSIX systems"
  homepage "https://tinyproxy.github.io/"
  url "https://github.com/tinyproxy/tinyproxy/releases/download/1.11.2/tinyproxy-1.11.2.tar.xz"
  sha256 "6a126880706691c987e2957b1c99b522efb1964a75eb767af4b30aac0b88a26a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia:  "2556f6c1aa3073beccdf952d8baf20c880300ef2d5067fe2588c43b7b58be0a2"
    sha256 arm64_sonoma:   "54a2231b4ad6b362db15d5709eb7ae1f171584e64725546b4ef5d5c384ca6b4c"
    sha256 arm64_ventura:  "38dd9771beb51039ef32c6f96e110726598387867c3bb22215298310e735aaeb"
    sha256 arm64_monterey: "77833ca6e2e9f3926d7f7a69c63aec9bb83da5241ba8ce6ed8c8ed1eaf2d1a6a"
    sha256 sonoma:         "e7f5a728df755d3fcb83b2639e924354c7bc479152bf766b819660b3caf1c302"
    sha256 ventura:        "11689d10c680a3c1e7b5fe372fe7ed44507e3e6415ab4dbf2b093a04f433bc2b"
    sha256 monterey:       "c581f25dbd95d8248cd632a11993c35ea42798ede63e2f27a59aa2bb875ff778"
    sha256 x86_64_linux:   "f63df2e51f811d5d80b7a2ce3f3e4bd0f170186061e937a39f1d06b787db793d"
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --localstatedir=#{var}
      --sysconfdir=#{etc}
      --disable-regexcheck
      --enable-filter
      --enable-reverse
      --enable-transparent
    ]

    system "./configure", *args
    system "make", "install"
  end

  def post_install
    (var/"log/tinyproxy").mkpath
    (var/"run/tinyproxy").mkpath
  end

  service do
    run [opt_bin/"tinyproxy", "-d"]
    keep_alive false
    working_dir HOMEBREW_PREFIX
  end

  test do
    port = free_port
    cp etc/"tinyproxy/tinyproxy.conf", testpath/"tinyproxy.conf"
    inreplace testpath/"tinyproxy.conf", "Port 8888", "Port #{port}"

    pid = fork do
      exec bin/"tinyproxy", "-c", testpath/"tinyproxy.conf"
    end
    sleep 2

    begin
      assert_match "tinyproxy", shell_output("curl localhost:#{port}")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
