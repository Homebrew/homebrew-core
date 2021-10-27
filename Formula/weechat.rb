class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-3.3.tar.xz"
  sha256 "cafeab8af8be4582ccfd3e74fd40e5086a1efa158231f2c26b8b05c3950fcbdf"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "4a1e008cf76feb26be4037753389ddd5259768e40478dce3e43089cb576ff12e"
    sha256 arm64_big_sur:  "e4f9d439f3a83efdf7c0f88fcc7d638c1b4b8a1bff55e6c6215c174ac3cddf16"
    sha256 monterey:       "c8c53f4df53f45f666515d0e012b54c05625a8fd9e155bcf964131bd96298c12"
    sha256 big_sur:        "f176eda50d9ef8ab5858b35a1a572c0bd50fd531f912f33210afdebb3e200677"
    sha256 catalina:       "ccfa0fff385966e6ff08de5e280f49defac48eafc0d649c3ebe983e0475631ff"
    sha256 mojave:         "e68941b11b7b86d8603c809420ac6fba6761ad095bcf5c6087d0f560dd542114"
    sha256 x86_64_linux:   "d7d367abe8fe2a22ac47b929332176d22215fa230f886d52be5f5f78e1c4c940"
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
