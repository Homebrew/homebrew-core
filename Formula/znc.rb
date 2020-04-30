class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/archive/znc-1.8.0.tar.gz"
  sha256 "94fdb227c1afa3abff468e0b7b1309120ad99d6aa64c4fd35bef02928171bd54"
  revision 1

  bottle do
    sha256 "709f3ab4bcf9e6a257d4033ff73cdeb44ec1c53b16a63a2c9135543cdc80dc82" => :catalina
    sha256 "18facada926ae46774edc0250934813e27e2f41aedef1b0ad7d1604893f07aca" => :mojave
    sha256 "623b6b791ca5e1ba8c2034e7ef1260e6ea849fe46a2d070ee925dfce758ed907" => :high_sierra
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
