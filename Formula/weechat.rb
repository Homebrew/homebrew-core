class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-3.2.1.tar.xz"
  sha256 "2bb3a708e006f2d22df9e813f3567569178f30ba4082fd8fb06ca0f6f4d1613f"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "011ded88c3b1e1e8019b1e27ae3aafefc038d5cda13b72364c909c9e9f4c97e4"
    sha256 big_sur:       "33535ba198766d65e0e6aa113eec1fcbb7b42ee10fd95599bc293def1861a2b1"
    sha256 catalina:      "d133800b9ff2027f6f8efe11c457f57e3033f963bc71fb1368bc6a6263c34aa0"
    sha256 mojave:        "c64d2e4761b4bae1c617c04f9d74f674d00a8b22f1da9701a9160ffe9ece52e2"
    sha256 x86_64_linux:  "06c45c9d62ac7dabff1cb9ecc2b4a94ebc4143bda709ef8d1993fac880286deb"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "aspell"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "perl"
  depends_on "python@3.9"
  depends_on "ruby"

  uses_from_macos "curl"
  uses_from_macos "tcl-tk"

  on_macos do
    depends_on "libiconv"
  end

  def install
    args = std_cmake_args + %W[
      -DENABLE_MAN=ON
      -DENABLE_GUILE=OFF
      -DCA_FILE=#{Formula["gnutls"].pkgetc}/cert.pem
      -DENABLE_JAVASCRIPT=OFF
      -DENABLE_PHP=OFF
    ]

    # Fix error: '__declspec' attributes are not enabled
    # See https://github.com/weechat/weechat/issues/1605
    args << "-DCMAKE_C_FLAGS=-fdeclspec" if ENV.compiler == :clang

    # Fix system gem on Mojave
    ENV["SDKROOT"] = ENV["HOMEBREW_SDKROOT"]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install", "VERBOSE=1"
    end
  end

  test do
    system "#{bin}/weechat", "-r", "/quit"
  end
end
