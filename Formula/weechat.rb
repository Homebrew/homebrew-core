class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-3.0.tar.xz"
  sha256 "6cb7d25a363b66b835f1b9f29f3580d6f09ac7d38505b46a62c178b618d9f1fb"
  license "GPL-3.0-or-later"
  revision 4
  head "https://github.com/weechat/weechat.git"

  bottle do
    sha256 "7d81a7239c7446a38b3e6d7f9e98b4dfce7fd4c0e5b9295db3ea479e79c5d1aa" => :big_sur
    sha256 "5836f21a2e0538ddaf7f9f43095da934acd4c837925134b70fabadccc5752b2c" => :arm64_big_sur
    sha256 "97bd849e8338428f259f10e7c50a6d82b62a0519c53d866ca646e02f3a85bb63" => :catalina
    sha256 "6ceb833768e2b6cbcde434e4c0fb5582ab04d72e97ceaf16a71c52ebcd5ef193" => :mojave
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
