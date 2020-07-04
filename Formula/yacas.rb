class Yacas < Formula
  desc "General purpose computer algebra system"
  homepage "https://www.yacas.org/"
  url "https://github.com/grzegorzmazur/yacas/archive/v1.9.1.tar.gz"
  sha256 "36333e9627a0ed27def7a3d14628ecaab25df350036e274b37f7af1d1ff7ef5b"
  license "LGPL-2.1"

  bottle do
    cellar :any_skip_relocation
    sha256 "19ab04af9d66b53b2686d7e7f8776751eebcecfc384870bc1f9b64daf140ed9a" => :catalina
    sha256 "7eddc6ecfe6269e3fe86f1187e091567029595f3cd217c31d4b27f13f40767a0" => :mojave
    sha256 "09a00e2be0c76797919a7d1d4b621755b2594c7ba01ae974a47d654df43681f7" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on :xcode => :build

  def install
    cmake_args = std_cmake_args + [
      "-DENABLE_CYACAS_GUI=OFF",
      "-DENABLE_CYACAS_KERNEL=OFF",
      "-DCMAKE_C_COMPILER=#{ENV.cc}",
      "-DCMAKE_CXX_COMPILER=#{ENV.cxx}",
    ]
    mkdir "build" do
      system "cmake", "..", "-G", "Xcode", *cmake_args
      ln_s "../libyacas/Release", "cyacas/libyacas_mp/Release"
      xcodebuild "-project", "yacas.xcodeproj", "-scheme", "ALL_BUILD",
                 "-configuration", "Release", "SYMROOT=build/cyacas/libyacas"
    end
    bin.install "build/cyacas/libyacas/Release/yacas"
    lib.install "build/cyacas/libyacas/Release/libyacas.a",
                "build/cyacas/libyacas/Release/libyacas_mp.a"
    pkgshare.install "scripts"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yacas -v")
  end
end
