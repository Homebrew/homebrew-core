class Taglib < Formula
  desc "Audio metadata library"
  homepage "https://taglib.github.io/"
  url "https://taglib.github.io/releases/taglib-1.11.1.tar.gz"
  sha256 "b6d1a5a610aae6ff39d93de5efd0fdc787aa9e9dc1e7026fa4c961b26563526b"
  head "https://github.com/taglib/taglib.git"

  bottle do
    cellar :any
    sha256 "a0a374439cbf94a6fb57d791abf0bc6fb974eef1cf21f66c2731d1fc83d2428d" => :sierra
    sha256 "edaf79d2a2ec72ae32d9b46621697626a27299226a6b4d963431da8c37d3af52" => :el_capitan
    sha256 "bfda081fd34cb47bcdfd41e814612dbdf330166e30e69867cf43fcac60e5ed1a" => :yosemite
  end

  option :cxx11

  depends_on "cmake" => :build

  def install
    ENV.cxx11 if build.cxx11?
    args = std_cmake_args + %w[
      -DWITH_MP4=ON
      -DWITH_ASF=ON
      -DBUILD_SHARED_LIBS=ON
    ]
    system "cmake", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taglib-config --version")
  end
end
