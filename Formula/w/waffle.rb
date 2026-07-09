class Waffle < Formula
  desc "C library for selecting an OpenGL API and window system at runtime"
  homepage "https://waffle.freedesktop.org/"
  url "https://waffle.freedesktop.org/files/release/waffle-1.8.3/waffle-1.8.3.tar.xz"
  sha256 "333751a6684370717d4d6327061834f2fbdfe687478d7d3c6b1ab27f57c90877"
  license "BSD-2-Clause"
  head "https://gitlab.freedesktop.org/mesa/waffle.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2dd69169a48a2d596930174abd4cb49de0c96f34283de5149573b9161a342d90"
    sha256 cellar: :any, arm64_sequoia: "38ea5644a64bb6ec2ddb776b680a1e66b0c95e8aae5eee55be80bfcee34a4d98"
    sha256 cellar: :any, arm64_sonoma:  "844f7d199beeefdee0d3c3c2a53cbc36f6aeb1ba353d989cf847cefc83fdd2a9"
    sha256 cellar: :any, sonoma:        "fa5ab19527be69be3cee70a91c16ac9b76cfcad22060a5b145f61c62d6150702"
    sha256               arm64_linux:   "2830fb4efe4539177bdf4446132863b66960fdf0b02176e5fae7b70a3364840c"
    sha256               x86_64_linux:  "ba6db6caea184960fb78adb9a63ba635e739c1cbd226c033e48cadc12756aba3"
  end

  depends_on "cmake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  uses_from_macos "libxslt" => :build

  on_linux do
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "systemd"
    depends_on "wayland"
  end

  def install
    args = %w[
      -Dbuild-examples=true
      -Dbuild-htmldocs=true
      -Dbuild-manpages=true
    ]

    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    cp_r prefix/"share/doc/waffle1/examples", testpath
    cd "examples"
    # Homebrew-specific work around for linker flag ordering problem in Ubuntu.
    unless OS.mac?
      inreplace "Makefile.example", "$(LDFLAGS) -o gl_basic gl_basic.c",
                "gl_basic.c $(LDFLAGS) -o gl_basic"
      inreplace "Makefile.example", "$(LDFLAGS) -o simple-x11-egl simple-x11-egl.c",
                "simple-x11-egl.c $(LDFLAGS) -o simple-x11-egl"
    end
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE" if OS.mac?
    system "make", "-f", "Makefile.example"
  end
end
