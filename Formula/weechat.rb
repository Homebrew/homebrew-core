class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-2.7.tar.xz"
  sha256 "56fc42a4afece57bc27f95a2d155815a5e6472f32535add4c0ab4ce3b5e399e7"
  head "https://github.com/weechat/weechat.git"

  bottle do
    sha256 "04c203005803864703852173c863f48838d7ee6813c83a5e14052f5998df91a6" => :catalina
    sha256 "a025d7e8d70aca0028d74e68923d48006ab1aca95f1e6b4150fa5abb0746ab1b" => :mojave
    sha256 "195f7ba0558bcdf1a3a2db41c4baf23a8ab1225c77af7b0aba924b275e0c0339" => :high_sierra
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "aspell"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libiconv"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "perl"
  depends_on "python"
  depends_on "ruby"

  def install
    args = std_cmake_args + %W[
      -DENABLE_MAN=ON
      -DENABLE_GUILE=OFF
      -DCA_FILE=#{etc}/openssl/cert.pem
      -DENABLE_JAVASCRIPT=OFF
      -DENABLE_PHP=OFF
    ]

    if MacOS.version >= :mojave && MacOS::CLT.installed?
      ENV["SDKROOT"] = ENV["HOMEBREW_SDKROOT"] = MacOS::CLT.sdk_path(MacOS.version)
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install", "VERBOSE=1"
    end
  end

  test do
    system "#{bin}/weechat", "-r", "/quit"
  end
end
