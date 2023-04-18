class Waffle < Formula
  desc "C library for selecting an OpenGL API and window system at runtime"
  homepage "https://waffle.freedesktop.org/"
  url "https://waffle.freedesktop.org/files/release/waffle-1.7.2/waffle-1.7.2.tar.xz"
  sha256 "f676195cfea58cc75ef2441c5616b2f1d5565a7d371a6aa655aff3cc67c7c2c9"
  license "BSD-2-Clause"
  head "https://gitlab.freedesktop.org/mesa/waffle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c49b293a55d1fc03a49c27f2932fedab240aaae603bf6de8c713a3f4472575b5"
    sha256 cellar: :any,                 arm64_big_sur:  "44e6ed255b8ddafc5572f25b1f65cc59477e2961176eda549aa558e54a6b44f6"
    sha256 cellar: :any,                 monterey:       "2f6bb76c9f4c50e79c627b6e2c2e954f128df89ff86ac3bda0a9007948290ae1"
    sha256 cellar: :any,                 big_sur:        "9753062a77bcff11767245914b40ba773844a58f0991cb0487c8b76d07a34cec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d8a1781ff86d13b723a635387f6a47c67c2133e0a786ada9e4b4233dedcdd19"
  end

  depends_on "cmake" => :build
  depends_on "docbook-xsl" => :build
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
    args = std_cmake_args + %w[
      -Dwaffle_build_examples=1
      -Dwaffle_build_htmldocs=1
      -Dwaffle_build_manpages=1
    ]

    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    cp_r prefix/"share/doc/waffle1/examples", testpath
    cd "examples"
    # Temporary Homebrew-specific work around for linker flag ordering problem in Ubuntu 16.04.
    # Remove after migration to 18.04.
    unless OS.mac?
      inreplace "Makefile.example", "$(LDFLAGS) -o gl_basic gl_basic.c",
                "gl_basic.c $(LDFLAGS) -o gl_basic"
      inreplace "Makefile.example", "$(LDFLAGS) -o simple-x11-egl simple-x11-egl.c",
                "simple-x11-egl.c $(LDFLAGS) -o simple-x11-egl"
    end
    system "make", "-f", "Makefile.example"
  end
end
