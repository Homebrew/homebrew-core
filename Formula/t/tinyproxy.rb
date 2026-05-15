class Tinyproxy < Formula
  desc "HTTP/HTTPS proxy for POSIX systems"
  homepage "https://tinyproxy.github.io/"
  url "https://github.com/tinyproxy/tinyproxy/releases/download/1.11.3/tinyproxy-1.11.3.tar.xz"
  sha256 "f05644fdf1211ba13754a354bebed909b5b39371b12cce8563c46929a75bedf6"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "ac4cbc5308a528478d5972dbc951c2420abc1049d7061823735b648f9d864fd7"
    sha256 arm64_sequoia: "e0c3141a074ebc5b4f27ab91d20b6b447133a55fcca98d3cdd95dbcec14e1b58"
    sha256 arm64_sonoma:  "470a9ac084a05572a106d0d2a439f1e55ee430e4c64d18b733fa602c1e75da2f"
    sha256 sonoma:        "6173900c0a425c4ed48996d324e1b6ee832e3ef0d5155efc59dd652ffa8907f6"
    sha256 arm64_linux:   "b1f3a4f99b21d044c93a0101dfbf11cd1a1c6ce86f3a0189c95337b95778a38d"
    sha256 x86_64_linux:  "cf643817026c5ef4e5a55611b4e097b258c15899ba1bf62d5a58461bdc9ef60d"
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    args = %W[
      --disable-silent-rules
      --localstatedir=#{var}
      --sysconfdir=#{etc}
      --disable-regexcheck
      --enable-filter
      --enable-reverse
      --enable-transparent
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"

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

    pid = spawn bin/"tinyproxy", "-c", testpath/"tinyproxy.conf"
    begin
      sleep 2
      assert_match "tinyproxy", shell_output("curl localhost:#{port}")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
