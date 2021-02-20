class Waffle < Formula
  desc "C library for selecting an OpenGL API and window system at runtime"
  homepage "http://www.waffle-gl.org/"
  url "https://gitlab.freedesktop.org/mesa/waffle/-/raw/website/files/release/waffle-1.6.2/waffle-1.6.2.tar.xz"
  sha256 "41ff9e042497e482c7294e210ebd9962e937631829a548e5811c637337cec5a5"
  license "BSD-2-Clause"
  head "https://gitlab.freedesktop.org/mesa/waffle.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "133071fd7e8f381261162a14a33a31ed13d8b743b4da92c9749e37bcabf5261c"
    sha256 cellar: :any, big_sur:       "2484b49e0b524c05c045caab09533473397905b6bcda35ce0336bcd5bb81bb17"
    sha256 cellar: :any, catalina:      "1c640687e4194aea3ee1654a484ee55c3a26c57955b883e7fb9d32151db3ccf9"
    sha256 cellar: :any, mojave:        "547df7826af57e6dfb59389e4dde24ec0c504a5a9fca13a3adf06caab07cfa81"
  end

  depends_on "cmake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :test

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
    system "make", "-f", "Makefile.example"
  end
end
