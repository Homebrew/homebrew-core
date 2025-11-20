class Tinyproxy < Formula
  desc "HTTP/HTTPS proxy for POSIX systems"
  homepage "https://tinyproxy.github.io/"
  url "https://github.com/tinyproxy/tinyproxy/releases/download/1.11.2/tinyproxy-1.11.2.tar.xz"
  sha256 "6a126880706691c987e2957b1c99b522efb1964a75eb767af4b30aac0b88a26a"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "01f10b26d4d6e3bcf831ca8b921981b9f873d81b6556e2b52b4784ec4805a54d"
    sha256 arm64_sequoia: "21a3f6222d7da183ec58cd51fd48d1513cae15311374c4e1cc63f564c0105707"
    sha256 arm64_sonoma:  "7dabc693da904911eae0f046229a16841a0655751c15e57ddb56bd05cbc6ddc0"
    sha256 sonoma:        "be4b5eec4472a4d922473d1c267397ac88d8114edc0fa761ec243aea70a9d56b"
    sha256 arm64_linux:   "5d3ed227aff8eb302a9fd053c1939e1bb968fef0e5aeb36204ec59b01749eb0a"
    sha256 x86_64_linux:  "dd37a722840d2d5e0366cba9377cd3d70abee9480845bb5200c7bb089f0a5e58"
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
