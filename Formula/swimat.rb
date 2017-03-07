class Swimat < Formula
  desc "Command Line Tool to help format Swift code"
  homepage "https://github.com/Jintin/Swimat"
  url "https://github.com/Jintin/Swimat/archive/v1.3.2.tar.gz"
  sha256 "b1174eb3085ca8bb1f0e92fd87614641a86e82ab8f52b48c68b1fbc95574bba0"
  head "https://github.com/Jintin/Swimat.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "afb03ff97abd634eb8d5650fdba20cbdc874b68e40542c2a6c0082afd8a97de1" => :sierra
    sha256 "b21a2dd90ed13653dd53ddf07c1cb1ee50ac8efa61a42603bf47fc5266614732" => :el_capitan
  end

  depends_on :xcode => "8.0"

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
