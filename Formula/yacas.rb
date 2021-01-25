class Yacas < Formula
  desc "General purpose computer algebra system"
  homepage "https://www.yacas.org/"
  url "https://github.com/grzegorzmazur/yacas/archive/v1.9.1.tar.gz"
  sha256 "36333e9627a0ed27def7a3d14628ecaab25df350036e274b37f7af1d1ff7ef5b"
  license "LGPL-2.1"

  bottle do
    cellar :any_skip_relocation
    sha256 "dfdc56a32f326522a385c3617b185381d056c860cab7aa7f97dde25ea32b29e8" => :big_sur
    sha256 "a063eb4d6d3cef50d8168b87d663da647231f526e2fd9cf3d912b377523161ef" => :arm64_big_sur
    sha256 "be746c1eb1e965cb3d87195fd0094eee7987dbd74b5f3945e1cfe3e6df3a73cb" => :catalina
    sha256 "80089e9a9b1e3d64648af1cc34b1142d79332510c6797ea3a2a922d4bf4ccbc2" => :mojave
    sha256 "10557868ce4e8aa9d146a15b79e0c13e30d3d73c5fee3edaff8e0475678d31bc" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on xcode: :build

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
