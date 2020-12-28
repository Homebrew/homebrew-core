class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-3.0.tar.xz"
  sha256 "6cb7d25a363b66b835f1b9f29f3580d6f09ac7d38505b46a62c178b618d9f1fb"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/weechat/weechat.git"

  bottle do
    sha256 "5a706cd428686054a8e2dbcae39466cb7a9a3d3e8bd8160d24421144d8f8ba3c" => :big_sur
    sha256 "d6aeb1040ef6a269d5d1c175b3c3be0951b37773372aad82a507a19dfe53a5bc" => :arm64_big_sur
    sha256 "ae89b52c202b3d9a04f6ed95ea5aa95b065a3e29a999a70abace53a4dc312aa6" => :catalina
    sha256 "6f20c8a394ad86077666e398d9e9fba4cc25a27a33a2d163a6f1ff8bd770a8a0" => :mojave
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
