class Tinyproxy < Formula
  desc "HTTP/HTTPS proxy for POSIX systems"
  homepage "https://tinyproxy.github.io/"
  url "https://github.com/tinyproxy/tinyproxy/releases/download/1.11.0/tinyproxy-1.11.0.tar.xz"
  sha256 "c1ec81cfc4c551d2c24e0227a5aeeaad8723bd9a39b61cd729e516b82eaa3f32"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "09f14baaf00f8b81093527e15240b0148479fea10fc3b08b7a8e25166a896fa8"
    sha256 arm64_big_sur:  "1bca9b6a68c9d9f747edb51c4466a068b74d78a3cccd86e82baa9556808b1150"
    sha256 monterey:       "95967b7fd40003e14977445eccdcc3bb9f18018c720f5e3a6b8d9d699786a2c4"
    sha256 big_sur:        "9528959f70fab4a85ac762699c97d7c4b6c5c7d588044954724d6b482b91cd10"
    sha256 catalina:       "fcc32a761f871900380306fb61ffcdfbf1172d2c9d8221b5e7be301c72cf3d30"
    sha256 mojave:         "7cbf77e2f1b40cb087200afa79aaf64b53b673da74a94eaf2e98077945019da0"
    sha256 x86_64_linux:   "96aa07f753bda61900d7032633a19f647ed6d464bdc761d613c35bdc547650a3"
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build

  def install
    # conf.c:412:21: error: use of undeclared identifier 'LINE_MAX'
    # https://github.com/tinyproxy/tinyproxy/commit/7168a42624fb9ce3305c9e666e44cc8a533af5f6
    # Patch already accepted upstream, but not usable due to upstream refactor. Remove on next release.
    inreplace "src/acl.c", "#include <limits.h>\n", ""
    inreplace "src/common.h", "#  include	<pwd.h>\n", "#  include	<pwd.h>\n#  include	<limits.h>\n"

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
