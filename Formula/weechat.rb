class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-3.6.tar.xz"
  sha256 "9d85d71b3b7d04c03bd35ab6501afa8b5b3c609dce7691709ec740fecc31f2de"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "7e7f561e05ebc99826c83c677f5c08fd6ebd56d26618134457bd810724328db7"
    sha256 arm64_big_sur:  "4f6ef5eea5ffbaf080cb8b61b0c7051900ba1052dcd341db6a5f51fa41ccca83"
    sha256 monterey:       "7313b4ff56fe4d99b23ccc4a80c19f1d1339e7a04ccac9bbbe5a3cef0be71342"
    sha256 big_sur:        "cfc3defaa0cb38b6618417922ebbeaaf4f03ab9840d8e969ef39176a1644087e"
    sha256 catalina:       "0ab97c7f5aea9dd8d2e4eb4d4e0154224281fc8d20eb9e060b77f3035c0228f2"
    sha256 x86_64_linux:   "cbf6804df535149c79dcae50e4f7c902a14fd7391a31e6e5d8973586be600e51"
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
  depends_on "python@3.10"
  depends_on "ruby"
  depends_on "zstd"

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
