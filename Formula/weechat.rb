class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-3.4.1.tar.xz"
  sha256 "7e088109ad5dfbcb08a9a6b1dd70ea8236093fed8a13ee9d9c98881d7b1aeae7"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "c2762e95aefde4cf94debb8b7c404b9ec0843b6a67d0d58a1029b7c6a42b8281"
    sha256 arm64_big_sur:  "aa101e9b35ea918bd69dac1fe5137c1c5f26349494b3118a7b8eb76a0e3891dd"
    sha256 monterey:       "1cd9d9ce5daaa13e703bc039ce49ff69c4d34b81263b6c7286556bbe5c364203"
    sha256 big_sur:        "27b183363bff4dee1d58c6f29900b9dc94cc3e25007b590d73e3750007ce747d"
    sha256 catalina:       "fc98311a9d38bad170e46a000ed0092809666349c846793a0cb70d0b07abf73d"
    sha256 x86_64_linux:   "be717d3b0ee1413128755dbc62eb1f693f616752ce0c3f2f7ee4f52b4c1e7790"
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
  depends_on "ruby@3.0"

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
