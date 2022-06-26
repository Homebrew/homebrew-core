class Tinyproxy < Formula
  desc "HTTP/HTTPS proxy for POSIX systems"
  homepage "https://tinyproxy.github.io/"
  url "https://github.com/tinyproxy/tinyproxy/releases/download/1.11.1/tinyproxy-1.11.1.tar.xz"
  sha256 "d66388448215d0aeb90d0afdd58ed00386fb81abc23ebac9d80e194fceb40f7c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "63eece964c5e41576d66c6e142ac0ab30dca56c488e4b3ac327de1f8f9374900"
    sha256 arm64_big_sur:  "ed35931fbe7004feb89145a3ccf75b1d39be9b79b7fb3c36be11b4c46d5dce54"
    sha256 monterey:       "53d3f8a42faef7373b2448c4f151a09b88e5b6d5434640e884c09f8e53449ec0"
    sha256 big_sur:        "7be798a814e31a8148ec6a9a01b7c238a623cc9742faa0d7dfe733663c356a23"
    sha256 catalina:       "7dcdad0316a57335efd2d7c1fff9de4ba458c38c7c5efa7d0a82f0212e16def0"
    sha256 x86_64_linux:   "07920f384cef0e204d966dd84dea766c57e181a1861ae453d1787e2b8e7e7b9e"
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
      exec "#{bin}/tinyproxy", "-c", testpath/"tinyproxy.conf"
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
