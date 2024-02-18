class WoofDoom < Formula
  desc "Woof! is a continuation of the Boom/MBF bloodline of Doom source ports"
  homepage "https://github.com/fabiangreffrath/woof"
  url "https://github.com/fabiangreffrath/woof/archive/refs/tags/woof_14.0.0.tar.gz"
  sha256 "b0571ccda5d9428091aa5e238980cc4c08a3c22db2d7d1a16faae636e245f93b"
  license "GPL-2.0-only"
  head "https://github.com/fabiangreffrath/woof.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "f34169caed3e3ae3f967062081bc2264dfd8f7c489295f334365d05532fb6457"
    sha256 arm64_ventura:  "2799c09860bf666263093918f50875c4d84bc2bacb494902b0dad99a62cc9278"
    sha256 arm64_monterey: "d87586621e1248927266ad8b0c8c891068f69c9167202eef330549d6681f2710"
    sha256 sonoma:         "3e120fcf86a1fa184c2c972f866e30caee5acc1e3ddbdf1fddd53c80feb1c34e"
    sha256 ventura:        "e5af57f848a0ab4ce594ccc3153f8c1959834b215d29ccdd1ec93e206bd80f81"
    sha256 monterey:       "59070ea05ecb8fed863696327378952c6b158f9f6c61b9b4d922ad7f8e4b70e9"
    sha256 x86_64_linux:   "d3afa3dfb4fd3653bfb48ca34b518f5fc530fede87b47923e31d8f8ef04d0c55"
  end

  depends_on "cmake" => :build
  depends_on "fluid-synth"
  depends_on "libsndfile"
  depends_on "libxmp"
  depends_on "openal-soft"
  depends_on "sdl2"
  depends_on "sdl2_net"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    testdata = <<~EOS
      Invalid IWAD file
    EOS
    (testpath/"test_invalid.wad").write testdata

    expected_output = "Wad file test_invalid.wad doesn't have IWAD or PWAD id"
    assert_match expected_output, shell_output("#{bin}/woof -nogui -iwad test_invalid.wad 2>&1", 255)
  end
end
