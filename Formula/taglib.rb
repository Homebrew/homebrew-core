class Taglib < Formula
  desc "Audio metadata library"
  homepage "https://taglib.github.io/"
  url "https://taglib.github.io/releases/taglib-1.11.tar.gz"
  sha256 "ed4cabb3d970ff9a30b2620071c2b054c4347f44fc63546dbe06f97980ece288"
  head "https://github.com/taglib/taglib.git"

  bottle do
    cellar :any
    sha256 "083ede2ae70eabf409a82e4999aa78f027ecb8c0b71065008eee90d4a4ccc59d" => :el_capitan
    sha256 "60a0e999802c0a3b4aced2375cbe0cb94744329bd9773beb18bbefb99b5692c4" => :yosemite
    sha256 "7f673f94a4263441327b83691f47c56605b8f4d20e7129c5d2883b8f603dcc15" => :mavericks
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
