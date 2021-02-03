class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-3.0.1.tar.xz"
  sha256 "781d9bfc7e1321447de9949263b82e3ee45639b7d71693558f40ff87211ca6dd"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git"

  bottle do
    sha256 arm64_big_sur: "15f4cfad8bb9b747b3bd1c891bc5d6f311027196811944c65add901d9f0e7359"
    sha256 big_sur:       "8df326e3e65fac4cb626046fc8742e19e86b1d74ada1bbe976a79037c21c9fbe"
    sha256 catalina:      "361962d068a97514bde638b03be6855f21c17d78fddfded1338eb12fd0f56eae"
    sha256 mojave:        "f486f55ee356c1fd21d4c4151588551fd4f3b0620bed54799e76c039e698851b"
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
  depends_on "python@3.9"
  depends_on "ruby"

  uses_from_macos "curl"
  uses_from_macos "tcl-tk"

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
