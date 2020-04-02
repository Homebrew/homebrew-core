class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/archive/znc-1.7.5.tar.gz"
  sha256 "a8941e1385c8654287a4428018d93459482e9d5eeedf86bef7b020ddc5f24721"
  revision 1

  bottle do
    rebuild 1
    sha256 "9dea1d38863b76a2e44bfa9f2d3a7a4f54e0100c3def895fba15d0170047e5d2" => :catalina
    sha256 "365117d77ba2c98af90941e564039b0be8e77bf87f0edfa6195b9dceb4acb37e" => :mojave
    sha256 "25d5dec6b535d2b39ffcbf68b0b740035f702e41f6d69fcae4b7d6343a5feece" => :high_sierra
  end

  head do
    url "https://github.com/znc/znc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "openssl@1.1"
  depends_on "python@3.8"

  uses_from_macos "zlib"

  def install
    ENV.cxx11
    # These need to be set in CXXFLAGS, because ZNC will embed them in its
    # znc-buildmod script; ZNC's configure script won't add the appropriate
    # flags itself if they're set in superenv and not in the environment.
    ENV.append "CXXFLAGS", "-std=c++11"
    ENV.append "CXXFLAGS", "-stdlib=libc++" if ENV.compiler == :clang

    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--enable-python"
    system "make", "install"
  end

  plist_options :manual => "znc --foreground"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/znc</string>
            <string>--foreground</string>
          </array>
          <key>StandardErrorPath</key>
          <string>#{var}/log/znc.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/znc.log</string>
          <key>RunAtLoad</key>
          <true/>
          <key>StartInterval</key>
          <integer>300</integer>
        </dict>
      </plist>
    EOS
  end

  test do
    mkdir ".znc"
    system bin/"znc", "--makepem"
    assert_predicate testpath/".znc/znc.pem", :exist?
  end
end
