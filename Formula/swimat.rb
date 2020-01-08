class Swimat < Formula
  desc "Command-line tool to help format Swift code"
  homepage "https://github.com/Jintin/Swimat"
  url "https://github.com/Jintin/Swimat/archive/v1.6.2.tar.gz"
  sha256 "1e6000dd16857a769070036fe710dd0b2aa6c4436a02ecc60590d829d6228e8b"
  head "https://github.com/Jintin/Swimat.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a94df9efa0aef16df8e593696a3dc3dd1fbe4f8fa59512af713d4915a103843c" => :catalina
    sha256 "197ba3d1db2bfbee29a10e4735925b4fdac3035c486b7899bc564cea5f019839" => :mojave
  end

  depends_on :xcode => ["10.2", :build]

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
