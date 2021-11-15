class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://nlnetlabs.nl/downloads/unbound/unbound-1.13.2.tar.gz"
  sha256 "0a13b547f3b92a026b5ebd0423f54c991e5718037fd9f72445817f6a040e1a83"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/NLnetLabs/unbound.git", branch: "master"

  # We check the GitHub repo tags instead of
  # https://nlnetlabs.nl/downloads/unbound/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url :head
    regex(/^(?:release-)?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "a4623b4e5433b7d66a50b3d478a29b37ffa9ae2d64ec3d34a73351bc6bd3d6b7"
    sha256 arm64_big_sur:  "be270411ac84da8f2e6424c50e9a24f2b6b332b98a0f82690c933b4f2aa03569"
    sha256 monterey:       "ecba34a33d7e30a3b2053fb57b9a6ccb4cf5ea85a6eb9bbe2c5cd365d2c15f57"
    sha256 big_sur:        "7f411a6ec21a1c46be319d79c7b7e43f4858e0751cd92b8e9fdd41b070265991"
    sha256 catalina:       "3519fe0e6677d759978c5a6d07f1eb576495e04146df01cdbd367506421d2ac2"
    sha256 mojave:         "79fc8a9f5c4579ee06a35966fa5e247037c8773519b3f29d67b7ef47e52db7b9"
    sha256 x86_64_linux:   "b96cfb9beaf9b62043260bc32e9d76dac680132842ee3089d6fd8698810884ce"
  end

  depends_on "libevent"
  depends_on "libnghttp2"
  depends_on "openssl@1.1"

  uses_from_macos "expat"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --enable-event-api
      --enable-tfo-client
      --enable-tfo-server
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-libnghttp2=#{Formula["libnghttp2"].opt_prefix}
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
    ]

    args << "--with-libexpat=#{MacOS.sdk_path}/usr" if OS.mac? && MacOS.sdk_path_if_needed
    args << "--with-libexpat=#{Formula["expat"].opt_prefix}" if OS.linux?
    system "./configure", *args

    inreplace "doc/example.conf", 'username: "unbound"', 'username: "@@HOMEBREW-UNBOUND-USER@@"'
    system "make"
    system "make", "install"
  end

  def post_install
    conf = etc/"unbound/unbound.conf"
    return unless conf.exist?
    return unless conf.read.include?('username: "@@HOMEBREW-UNBOUND-USER@@"')

    inreplace conf, 'username: "@@HOMEBREW-UNBOUND-USER@@"',
                    "username: \"#{ENV["USER"]}\""
  end

  plist_options startup: true

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>KeepAlive</key>
          <true/>
          <key>RunAtLoad</key>
          <true/>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_sbin}/unbound</string>
            <string>-d</string>
            <string>-c</string>
            <string>#{etc}/unbound/unbound.conf</string>
          </array>
          <key>UserName</key>
          <string>root</string>
          <key>StandardErrorPath</key>
          <string>/dev/null</string>
          <key>StandardOutPath</key>
          <string>/dev/null</string>
        </dict>
      </plist>
    EOS
  end

  test do
    system sbin/"unbound-control-setup", "-d", testpath
  end
end
