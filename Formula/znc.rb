class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/archive/znc-1.7.1.tar.gz"
  sha256 "44cfea7158ea05dc2547c7c6bc22371e66c869def90351de0ab90a9c200d39c4"
  revision 1

  bottle do
    sha256 "29762087ad3267dd6b7164aad34e6cbe6316efe0d5d858b6bb20405b89f37e05" => :mojave
    sha256 "3fbeaad6f7f86d78aee001eb16f1093fa40a88cc9ccd4da4f29a35b06912d1e1" => :high_sierra
    sha256 "b3bd651781f249b40cced788e3322a9ae09fd78d31ebd3bbfba073dd35666793" => :sierra
  end

  head do
    url "https://github.com/znc/znc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "openssl"
  depends_on "python"

  needs :cxx11

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

  def plist; <<~EOS
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
