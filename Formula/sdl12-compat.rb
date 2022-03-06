class Sdl12Compat < Formula
  desc "SDL 1.2 compatibility layer that uses SDL 2.0 behind the scenes"
  homepage "https://github.com/libsdl-org/sdl12-compat"
  url "https://github.com/libsdl-org/sdl12-compat/archive/refs/tags/release-1.2.52.tar.gz"
  sha256 "5bd7942703575554670a8767ae030f7921a0ac3c5e2fd173a537b7c7a8599014"
  license all_of: ["Zlib", "MIT-0"]
  head "https://github.com/libsdl-org/sdl12-compat.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "c72990e0bd8eeebf2f8ee531035182fd34d2cb2ef04f64b813275296064ff5dc"
    sha256 cellar: :any, arm64_big_sur:  "407f9525d90e488edadc9a6ef05c308ac27295170a89c894a4d056f54f9def4e"
    sha256 cellar: :any, monterey:       "552eef2e5ab22982606a9430bb9eefda7a3dab522454d5a8ec264d9c53edd046"
    sha256 cellar: :any, big_sur:        "135e798141fdbe40bdea14109d7eb0f4aa3071966da9a383cc5ea498e78e20c4"
    sha256 cellar: :any, catalina:       "294c5daaea49dbd8be67fb90122c81a03b48aed25690bac23a93bd19596360f3"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

  conflicts_with "sdl", because: "sdl12-compat is a drop-in replacement for sdl"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DSDL2_PATH=#{Formula["sdl2"].opt_prefix}",
                    "-DSDL12DEVEL=ON",
                    "-DSDL12TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (lib/"pkgconfig").install_symlink "sdl12_compat.pc" => "sdl.pc"
  end

  test do
    assert_predicate lib/shared_library("libSDL"), :exist?
    assert_predicate lib/shared_library("libSDL-1.2.0"), :exist?
    assert_predicate lib/"libSDLmain.a", :exist?
    assert_equal version.to_s, shell_output("#{bin}/sdl-config --version").strip
  end
end
