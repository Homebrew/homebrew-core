class Yacas < Formula
  desc "General purpose computer algebra system"
  homepage "http://www.yacas.org/"
  url "https://github.com/grzegorzmazur/yacas/archive/v1.6.1.tar.gz"
  sha256 "6b94394f705bed70a9d104967073efd6c23e9eb1a832805c4d805ef875555ae5"

  bottle do
    rebuild 1
    sha256 "95808542ccd26e5286a42411c0f848bebd63ece8315d4ac92742639bee5eb049" => :sierra
    sha256 "700fa65e0279625861a0f7166c3e213c807ed7ea46b5f10d5ba6be920aa76a64" => :el_capitan
    sha256 "c143a1764ec3dd64563e78e75c09b11d519124a10c97614bd5c6fbc99bab058b" => :yosemite
    sha256 "52c5071ec1f10c3181d11be1cd54d345fef5cdcbd4dcd6ef1d2cd71a8cff1d85" => :mavericks
    sha256 "c3fb8303de3f7e455047994b26b0cb7edbdee3c466eb77e22a66c42746ea766e" => :mountain_lion
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
