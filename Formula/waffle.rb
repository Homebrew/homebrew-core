class Waffle < Formula
  desc "C library for selecting an OpenGL API and window system at runtime"
  homepage "http://www.waffle-gl.org/"
  url "https://gitlab.freedesktop.org/mesa/waffle/-/raw/website/files/release/waffle-1.7.0/waffle-1.7.0.tar.xz"
  sha256 "69e42d15d08f63e7a54a8b8770295a6eb04dfd1c6f86c328b6039dbe7de28ef3"
  license "BSD-2-Clause"
  head "https://gitlab.freedesktop.org/mesa/waffle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6ea98899df47ceb529895748932fd08dfabbd53a34ff8e153279aa59b1ee8e37"
    sha256 cellar: :any,                 arm64_big_sur:  "2978050a3df20c384641d00498cc83255c945999ed249d9d7d2e33d24998e387"
    sha256 cellar: :any,                 monterey:       "5c022615ff6bcd7d59cd1fc8147ebb26ae12bff7dc104db3178bd1d5655eca0d"
    sha256 cellar: :any,                 big_sur:        "a382e396564e8eda224154272ab33584cdedc1978d096e0989aef1bf8aea4edc"
    sha256 cellar: :any,                 catalina:       "f7a2dfc36d15d76318ee9e22277675818b75311f442792c2c979121df7fdd1af"
    sha256 cellar: :any,                 mojave:         "2f865431b367967e1ec77232813930923f3435332972334933cb4a0173a061b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2b0bf74c8eed8e3a8b3f85f62d4bb01172916808acc31ee74878833632e7825"
  end

  depends_on "cmake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :test

  uses_from_macos "libxslt" => :build

  on_linux do
    depends_on "libxcb"
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "systemd"
    depends_on "wayland"
  end

  # Apply upstream commit to fix build with wayland 1.20.  Remove with next release.
  patch do
    url "https://gitlab.freedesktop.org/mesa/waffle/-/commit/2c33597245bb74f19104f0a858cd40e80b26991d.diff"
    sha256 "739b2699349535c7f9fbc0efc7ca880c59cc8208fbf4ffacb5050dcfdf7c753c"
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
