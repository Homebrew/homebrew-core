class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/archive/znc-1.8.0.tar.gz"
  sha256 "94fdb227c1afa3abff468e0b7b1309120ad99d6aa64c4fd35bef02928171bd54"

  bottle do
    sha256 "8f2902352bfff8c586709207b58b7d3c2eee2c7b6a3be1e0b8693dac62ef4f08" => :catalina
    sha256 "4f1e7688f53fafece49245e30b6f33245b091792f1f14f4a13e50619b0a3bacf" => :mojave
    sha256 "1c5f32604ecee0941c235c5b2730299ab02a4f0a5c44e8ac5860b0d5f35664d4" => :high_sierra
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
