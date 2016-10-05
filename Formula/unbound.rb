class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://unbound.net/downloads/unbound-1.5.10.tar.gz"
  sha256 "a39b8b4fcca2a2b35a2daa53fe35150cc3f09038dc9acede09c912fc248a9486"

  bottle do
    cellar :any
    sha256 "96e9154693efc3cdcad0e80c9236448218c0fe6b4b958c9e8111c24a4277c94d" => :sierra
    sha256 "da31692ef5cf6a8fd3910e90b4eae50e4bfb261d8abfea0893bc0b921ed72637" => :el_capitan
    sha256 "f873d5c0fac865009e8e49cd216ff0920c398327718cf47a1c667ae46f2cdb12" => :yosemite
  end

  depends_on "openssl"
  depends_on "libevent"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-ssl=#{Formula["openssl"].opt_prefix}
    ]
    args << "--with-libexpat=#{MacOS.sdk_path}/usr" unless MacOS::CLT.installed?
    system "./configure", *args

    inreplace "doc/example.conf", 'username: "unbound"', 'username: "@@HOMEBREW-UNBOUND-USER@@"'
    system "make", "install"
  end

  def post_install
    if File.read(etc/"unbound/unbound.conf").include?('username: "@@HOMEBREW-UNBOUND-USER@@"')
      inreplace etc/"unbound/unbound.conf", 'username: "@@HOMEBREW-UNBOUND-USER@@"', "username: \"#{ENV["USER"]}\""
    end
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
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
