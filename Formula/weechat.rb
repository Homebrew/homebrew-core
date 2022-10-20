class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-3.7.tar.xz"
  sha256 "6bd6962581331d31f4d4f8da489a1d0e8315038001bc00afcd306e58db0a0c54"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "a4b8803067d09d05ddd2eefc690627488d1c049f67d0a6909769602bb05b36d0"
    sha256 arm64_big_sur:  "ed5ff3c975fa7c5aabb01f5ff045492e8df06d898564f14e487bec5b6bad4298"
    sha256 monterey:       "321cfe51bc153a875c6b2df8df4f4231c065cad8e69b049ed89c9aac804fe0c8"
    sha256 big_sur:        "864ef4abaaf06929bb043d62e3d042dd1ef7218ececf067afde9e1e3c32c9b49"
    sha256 catalina:       "411ba0fbde5ad5fd43f5cc3de1bd6e95536a4ed89179892106baace0b74e5c5a"
    sha256 x86_64_linux:   "3df6173f04596dafa32385e3bea9938b40b7249a351ad8b46bdd8de33085350c"
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
