class Taglib < Formula
  desc "Audio metadata library"
  homepage "https://taglib.org/"
  url "https://taglib.github.io/releases/taglib-1.12.tar.gz"
  sha256 "7fccd07669a523b07a15bd24c8da1bbb92206cb19e9366c3692af3d79253b703"
  license "LGPL-2.1"
  head "https://github.com/taglib/taglib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d7da1273d1a9783afb09395ffd9ab622c2e889c16ec527257b47799fe7cffdb5"
    sha256 cellar: :any,                 arm64_big_sur:  "e76adce741330b6648c33971004f1101b42fac129fc78303e83932c27cb38b2d"
    sha256 cellar: :any,                 monterey:       "ec0c940b452bf46af5dbca8d88390c8d319c7c9b76d33d70740d87b6caac531b"
    sha256 cellar: :any,                 big_sur:        "d24fee8c8c6f491a2c078a84fbcba5f36e0381bf230ff3c35893a46cfe3e3c70"
    sha256 cellar: :any,                 catalina:       "766531146ab62a88352ad1718b14ec2461951d25feb3c1111a3005071b4c2e9a"
    sha256 cellar: :any,                 mojave:         "f63f8ade1e478f04697481873468017fa06fb78fbe7a8fe42ba2a67533496f57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "367b12ef8f720e08c4eb9af6e7603893fae239a3fd3f1da5e478df135a5aa496"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    system "cmake", "-DWITH_MP4=ON", "-DWITH_ASF=ON", "-DBUILD_SHARED_LIBS=ON",
                    *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taglib-config --version")
  end
end
