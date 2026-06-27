class Waffle < Formula
  desc "C library for selecting an OpenGL API and window system at runtime"
  homepage "https://waffle.freedesktop.org/"
  url "https://waffle.freedesktop.org/files/release/waffle-1.8.2/waffle-1.8.2.tar.xz"
  sha256 "1254afcddc7e2971fd1f8a543c7d0882d254a09d154fab00fe9fb5f4037b9f1c"
  license "BSD-2-Clause"
  head "https://gitlab.freedesktop.org/mesa/waffle.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f2b378a19c7db8dd6503b5e1bfd3effe5580fd91cb82d9b67c1d339d7f031ae0"
    sha256 cellar: :any, arm64_sequoia: "d3e9d8cb0d6e7ee1b7526d2c03a2c75013ecd63f76d62844e6c5a236144cfc34"
    sha256 cellar: :any, arm64_sonoma:  "1dc758c373579b8fabc18fdbccf1e82467a4c0cd175d61b251fab7cf82800ef6"
    sha256 cellar: :any, sonoma:        "5b7a69dfb5adbd9bd9f00dc926da434ba788b61ef08e169e6986e3f4d67e8402"
    sha256               arm64_linux:   "67044219cec4d300f29b7925db5c85422fa0569683c81fa50a1a358036b24067"
    sha256               x86_64_linux:  "5222c94e098d3c6bcc26145aab343651db5bdb78d3436f7b7e3e898659acc48c"
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
