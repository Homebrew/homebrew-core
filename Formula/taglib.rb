class Taglib < Formula
  desc "Audio metadata library"
  homepage "https://taglib.github.io/"
  url "https://taglib.github.io/releases/taglib-1.11.tar.gz"
  sha256 "ed4cabb3d970ff9a30b2620071c2b054c4347f44fc63546dbe06f97980ece288"
  head "https://github.com/taglib/taglib.git"

  bottle do
    cellar :any
    sha256 "bfcd6575c21fce26f3f49cfc43fb30b46906749d81d757e10597b6fdbaf8b512" => :el_capitan
    sha256 "e5a9e62fc16e32b8ad3239a712bf3eab630b245ed397bd957d1b89e2a807e310" => :yosemite
    sha256 "2e0df8adfa080dc22265478490aca953384e97d41e9421b110ef142e07d15ab2" => :mavericks
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
