class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://www.unbound.net/downloads/unbound-1.7.0.tar.gz"
  sha256 "94dd9071fb13d8ccd122a3ac67c4524a3324d0e771fc7a8a7c49af8abfb926a2"

  bottle do
    sha256 "8c7e2cd18ce125440cfc6545de5fb437c4e4a386786211c9b0956406b00169e7" => :high_sierra
    sha256 "9cfd4dc5892ae2a762b5413b2fe61ff18c59aea036a56a6616699e5b992e234b" => :sierra
    sha256 "701dbf2f8fbccfee9a8f843814639eb65d8fbcc57a8802a96964077a95f059b8" => :el_capitan
  end

  deprecated_option "with-python" => "with-python@2"

  depends_on "openssl"
  depends_on "libevent"
  depends_on "python@2" => :optional
  depends_on "swig" if build.with? "python@2"

  # https://www.nlnetlabs.nl/bugs-script/show_bug.cgi?id=4043
  # Remove for unbound >1.7.0
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/2081bc5e/unbound/unbound-1.7.0-fix-v6-make-test.diff"
    sha256 "acae8f6aa8f5d1044dab9a9bf8782263786c853bb38e1b59a9f18d866e01a1f4"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-ssl=#{Formula["openssl"].opt_prefix}
    ]

    if build.with? "python@2"
      ENV.prepend "LDFLAGS", `python-config --ldflags`.chomp
      ENV.prepend "PYTHON_VERSION", "2.7"

      args << "--with-pyunbound"
      args << "--with-pythonmodule"
      args << "PYTHON_SITE_PKG=#{lib}/python2.7/site-packages"
    end

    args << "--with-libexpat=#{MacOS.sdk_path}/usr" unless MacOS::CLT.installed?
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
