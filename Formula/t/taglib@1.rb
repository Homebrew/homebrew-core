class TaglibAT1 < Formula
  desc "Audio metadata library"
  homepage "https://taglib.org/"
  url "https://taglib.github.io/releases/taglib-1.13.1.tar.gz"
  sha256 "c8da2b10f1bfec2cd7dbfcd33f4a2338db0765d851a50583d410bacf055cfd0b"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]

  keg_only :versioned_formula

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    args = ["-DWITH_MP4=ON", "-DWITH_ASF=ON", "-DBUILD_SHARED_LIBS=ON"]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taglib-config --version")
  end
end
