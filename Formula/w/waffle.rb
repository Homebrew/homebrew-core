class Waffle < Formula
  desc "C library for selecting an OpenGL API and window system at runtime"
  homepage "https://waffle.freedesktop.org/"
  url "https://waffle.freedesktop.org/files/release/waffle-1.8.0/waffle-1.8.0.tar.xz"
  sha256 "29f462b5ea93510f585ae59b09f1aef6f9bad7287c7b82a7e8bd88f766e3afc7"
  license "BSD-2-Clause"
  head "https://gitlab.freedesktop.org/mesa/waffle.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "9262c7229fc67f91e8c58e7dccf11ebc7652d63925f6488704f087975ed67647"
    sha256 cellar: :any, arm64_ventura:  "6af22d78936c2b6e67001861b7a4a449649914a5cba4adf2d0bef1fd7c6bf029"
    sha256 cellar: :any, arm64_monterey: "26ae9441eede32d245fb40bfeda38953e73b361ed1a504f7429d857107b48c41"
    sha256 cellar: :any, sonoma:         "0aef39cc92a84c10da9114377a516c59ff4c11ed644ade74b22349bcfedbb9c1"
    sha256 cellar: :any, ventura:        "147a48d3cde58b8e210e82353c420c22e0bc357d50546da5d45315b1f2178342"
    sha256 cellar: :any, monterey:       "8ad7eec2aa3521e34bf908c5795e3a3ae5d3bc84a48d14ee509f6e5fac04a5c5"
    sha256               x86_64_linux:   "8e9c5d2b594568c7f49e447824a3e7d1f6c0da7de6fad365ecfc83822d0a30ea"
  end

  depends_on "docbook-xsl" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]

  uses_from_macos "libxslt" => :build

  on_linux do
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
