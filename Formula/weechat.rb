class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-3.0.tar.xz"
  sha256 "6cb7d25a363b66b835f1b9f29f3580d6f09ac7d38505b46a62c178b618d9f1fb"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/weechat/weechat.git"

  bottle do
    sha256 "658fddd4482922db0279597fe57423c5a603ab1ddeb2af3be206a92fe5a44cf7" => :big_sur
    sha256 "351d3edc4d64723ebf501f58a2b4819c7df953e64f3eda7602bd0fef285606f8" => :arm64_big_sur
    sha256 "bc3e89725f90bcca4dd41e7b8e0f12c8ab2fb8f31194e0eb5cb55029bb036db0" => :catalina
    sha256 "662c25bdada863d62370aa5681a3cd55dcc566e1567147b02a006ded992c8dc7" => :mojave
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
    args << "-DCMAKE_C_FLAGS=-fdeclspec"

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
