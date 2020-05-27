class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://nlnetlabs.nl/downloads/unbound/unbound-1.10.1.tar.gz"
  sha256 "b73677c21a71cf92f15cc8cfe76a3d875e40f65b6150081c39620b286582d536"
  head "https://github.com/NLnetLabs/unbound.git"

  bottle do
    sha256 "7f66893bc42c776fb8437ae87c27b744fa30ebbea4dc349cb43aa72114b79937" => :catalina
    sha256 "04dfb0c9becb94b0e76ad11ba6b0ba70fae5bf5101533e57ac4ec2f9c8d31f5d" => :mojave
    sha256 "ba37bc57cd6a16c16e10ecd79c159849ffd16ef90845d0d50253c45b958fb8b3" => :high_sierra
  end

  depends_on "libevent"
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
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
    ]

    args << "--with-libexpat=#{MacOS.sdk_path}/usr" if MacOS.sdk_path_if_needed
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

  plist_options :startup => true

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
