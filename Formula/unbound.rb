class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://www.unbound.net/downloads/unbound-1.7.3.tar.gz"
  sha256 "c11de115d928a6b48b2165e0214402a7a7da313cd479203a7ce7a8b62cba602d"
  head "https://nlnetlabs.nl/svn/unbound/trunk/", :using => :svn

  bottle do
    rebuild 2
    sha256 "05d20ee709aaa08166007a9602b21a72d4c3fbd7b00f3d832e37a48d5423137e" => :mojave
    sha256 "c87c9cde683c23c0512626c58655e36416bb3249a0a3f4fd41b4c6c22e95c43b" => :high_sierra
    sha256 "7f8c5a827a566bbf5e664f434c97a57eb772c79f497d4fe419418fbbc74ec449" => :sierra
  end

  depends_on "libevent"
  depends_on "openssl"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-ssl=#{Formula["openssl"].opt_prefix}
    ]

    args << "--with-libexpat=#{MacOS.sdk_path}/usr" if MacOS.sdk_path_if_needed
    system "./configure", *args

    inreplace "doc/example.conf", 'username: "unbound"', 'username: "@@HOMEBREW-UNBOUND-USER@@"'
    system "make"
    system "make", "test"
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

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-/Apple/DTD PLIST 1.0/EN" "http:/www.apple.com/DTDs/PropertyList-1.0.dtd">
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
