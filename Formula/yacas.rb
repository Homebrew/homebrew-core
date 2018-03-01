class Yacas < Formula
  desc "General purpose computer algebra system"
  homepage "https://www.yacas.org/"
  url "https://github.com/grzegorzmazur/yacas/archive/v1.6.1.tar.gz"
  sha256 "6b94394f705bed70a9d104967073efd6c23e9eb1a832805c4d805ef875555ae5"

  bottle do
    cellar :any
    sha256 "33d32dbda388df190fa352f24cd6792f8d98a8af0a36fdd2f9d8951ae9c4e03a" => :high_sierra
    sha256 "6aef11d42795146a35f9f3b374dfdfbe79b89b5a57c15a7fb3510d27b522c251" => :sierra
    sha256 "807fafec64ac4c3589f5b760299d3b8fd42b29a66a914a5e6c119337a63bb6ab" => :el_capitan
    sha256 "c7fb1eb19bdb219645ed2bc94cfed491de1c2eb1f770dfd7a7b4cc63871f0dab" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on :xcode => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-G", "Xcode", "-DENABLE_CYACAS_GUI=OFF",
                            "-DENABLE_CYACAS_KERNEL=OFF", *std_cmake_args
      xcodebuild "-target", "ALL_BUILD", "-project", "YACAS.xcodeproj",
                 "-configuration", "Release", "SYMROOT=build/cyacas/libyacas"
    end
    bin.install "build/cyacas/libyacas/Release/yacas"
    lib.install Dir["build/cyacas/libyacas/Release/{libyacas.a,yacas.framework}"]
    pkgshare.install "scripts"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yacas -v")
  end
end
