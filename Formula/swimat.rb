class Swimat < Formula
  desc "Command Line Tool to help format Swift code"
  homepage "https://github.com/Jintin/Swimat"
  url "https://github.com/Jintin/Swimat/archive/v1.3.3.tar.gz"
  sha256 "6fea933a4d96ce84ecd03cf026c8fca7b81fb9a7749d0ca464b8cd467bd2bd5a"
  head "https://github.com/Jintin/Swimat.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "640cf7210dd5ef0a87f695bc298024e5248f7dd6697c3200d13af0f6a438fd08" => :sierra
    sha256 "6eee08900c80c2771f2925c535a04b59023db88c0d079cd40607338b32801dae" => :el_capitan
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
