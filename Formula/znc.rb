class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/archive/znc-1.8.2.tar.gz"
  sha256 "ff238aae3f2ae0e44e683c4aee17dc8e4fdd261ca9379d83b48a7d422488de0d"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 arm64_big_sur: "18345054b7781bf24544da8e0518b47b690b758072b779d92e08c5293a6ef49a"
    sha256 big_sur:       "2efca6c0d0c2de07b12406e0a9fe31210b3bacd025d99488cfeda148d64bbe1f"
    sha256 catalina:      "2b4458ad2b2625a49bb18a18b057c19a4d71803d86220947830eb67a0b7399ca"
    sha256 mojave:        "2d13c5d62b773e03f9dc5c376a0c90a0c14fe32e87c6ed88653fb77c5cdce390"
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
  depends_on "python@3.9"

  uses_from_macos "zlib"

  def install
    ENV.cxx11
    # These need to be set in CXXFLAGS, because ZNC will embed them in its
    # znc-buildmod script; ZNC's configure script won't add the appropriate
    # flags itself if they're set in superenv and not in the environment.
    ENV.append "CXXFLAGS", "-std=c++11"
    ENV.append "CXXFLAGS", "-stdlib=libc++" if ENV.compiler == :clang

    on_linux do
      ENV.append "CXXFLAGS", "-I#{Formula["zlib"].opt_include}"
      ENV.append "LIBS", "-L#{Formula["zlib"].opt_lib}"
    end

    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--enable-python"
    system "make", "install"
  end

  plist_options manual: "znc --foreground"

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
