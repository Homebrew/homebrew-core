class Waffle < Formula
  desc "C library for selecting an OpenGL API and window system at runtime"
  homepage "http://www.waffle-gl.org/"
  url "https://gitlab.freedesktop.org/mesa/waffle/-/raw/website/files/release/waffle-1.6.3/waffle-1.6.3.tar.xz"
  sha256 "30e47bb78616e5deab1b94fd901c629a42b6ec3bf693c668217d4d5fd9b62219"
  license "BSD-2-Clause"
  head "https://gitlab.freedesktop.org/mesa/waffle.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e3c1a264e214314ec29c4541a615fa052e1667f998b14f55349df21d3ab2994d"
    sha256 cellar: :any, big_sur:       "c241c542967b4d1e19477823186e6e42bd0c90ccf49796a0f796c8ac933b63fc"
    sha256 cellar: :any, catalina:      "9837f5e10a09639fb08921412a8a881688348335034343a564539b619ef3f421"
    sha256 cellar: :any, mojave:        "875998b76a6e9d345faafb3d01cf64891e94ec30b46c5a65a9effe43666745d6"
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
