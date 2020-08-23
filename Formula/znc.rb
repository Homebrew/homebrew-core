class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/archive/znc-1.8.1.tar.gz"
  sha256 "3195f7614a800a843af12271593d39cd3eb40c15657cce56d9cf28754cd86141"
  license "Apache-2.0"

  bottle do
    sha256 "005cacad69c5a76df51fec1b909618bc3c6607e35c242ce3fb7a072691c27cc5" => :catalina
    sha256 "acf1a6758351f662fba78bff2d08664000290c4e1f92bf2cfa7e160827110c91" => :mojave
    sha256 "3f9ed65af25e3b5edeb3c07a78b24e96944a4d05acec6c13b1336d3ce06ae0c0" => :high_sierra
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
