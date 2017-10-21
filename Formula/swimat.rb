class Swimat < Formula
  desc "Command-line tool to help format Swift code"
  homepage "https://github.com/Jintin/Swimat"
  url "https://github.com/Jintin/Swimat/archive/v1.5.0.tar.gz"
  sha256 "7e36348c7811e60af1489c689adc957d3461e50b927dab1436977aef8ceab3d3"
  head "https://github.com/Jintin/Swimat.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "af9476b0140190cc8e5d3e4e3982208b51c45bbc2398f7e7d896a1cbb2d21852" => :high_sierra
    sha256 "2979e199995f3f698bcab4ab6522b948d4c99420bfa9699d7c9f1f78440b70ef" => :sierra
  end

  depends_on :xcode => "9.0"

  def install
    xcodebuild "-target", "CLI",
               "-configuration", "Release",
               "CODE_SIGN_IDENTITY=",
               "SYMROOT=build"
    bin.install "build/Release/swimat"
  end

  test do
    system "#{bin}/swimat", "-h"
    (testpath/"SwimatTest.swift").write("struct SwimatTest {}")
    system "#{bin}/swimat", "#{testpath}/SwimatTest.swift"
  end
end
