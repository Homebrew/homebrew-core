class Yacas < Formula
  desc "General purpose computer algebra system"
  homepage "https://www.yacas.org/"
  url "https://github.com/grzegorzmazur/yacas/archive/v1.8.0.tar.gz"
  sha256 "25ebdafaec032eb4f39a12d87afc6cf9bf63ab952479a4839a71df92da5a981b"

  bottle do
    cellar :any_skip_relocation
    sha256 "19ab04af9d66b53b2686d7e7f8776751eebcecfc384870bc1f9b64daf140ed9a" => :catalina
    sha256 "7eddc6ecfe6269e3fe86f1187e091567029595f3cd217c31d4b27f13f40767a0" => :mojave
    sha256 "09a00e2be0c76797919a7d1d4b621755b2594c7ba01ae974a47d654df43681f7" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on :xcode => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-G", "Xcode", "-DENABLE_CYACAS_GUI=OFF",
                            "-DENABLE_CYACAS_KERNEL=OFF", *std_cmake_args
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
