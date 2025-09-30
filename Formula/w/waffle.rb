class Waffle < Formula
  desc "C library for selecting an OpenGL API and window system at runtime"
  homepage "https://waffle.freedesktop.org/"
  url "https://waffle.freedesktop.org/files/release/waffle-1.8.1/waffle-1.8.1.tar.xz"
  sha256 "f616c0ca6072d36bf81fb79a3695799973a978775e0213744bf0a39be6367425"
  license "BSD-2-Clause"
  head "https://gitlab.freedesktop.org/mesa/waffle.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:    "aac60d0464beecfe42add4b1be34ca27c1eaf49361202afb805df8acec7c024f"
    sha256 cellar: :any, arm64_sequoia:  "eb655477acb0eb6fe4a81e4ef5ba36d9d489df1bee0081d8e928b81c420168cd"
    sha256 cellar: :any, arm64_sonoma:   "0390ae70fb5f03b0625daaead204fdafe05e14452075f3251b589c1fd3e54515"
    sha256 cellar: :any, arm64_ventura:  "f49b790d1b6852b8d3568de22cb147bb63762adf37929988d225caa76acadc2e"
    sha256 cellar: :any, arm64_monterey: "1d9fe5d73c406d4026183163af71d1b59ba96a090bff3d3190eac32cf99928af"
    sha256 cellar: :any, sonoma:         "a59ee0f3ad1c4f4a47c07661e1439f4156dd10b88038115765ef51173282d597"
    sha256 cellar: :any, ventura:        "be09dc2b2af894dd48245599720c93135c7edd32fa01d5cc80bbd9fbfc0aec43"
    sha256 cellar: :any, monterey:       "445f768e3b9d4bb8a5e53741cb57acafe5a64d01d3454528326dafdacda4ca34"
    sha256               arm64_linux:    "2cdfe7169a64ad8138255aca48128fdc8d23b9885224cddac2a23bcdb3ceabc1"
    sha256               x86_64_linux:   "e66ab6325cd9b5b39752985ee80e3724e9affd46a75d1d2c7b764f6fbbe87b9b"
  end

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
