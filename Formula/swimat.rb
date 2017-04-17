class Swimat < Formula
  desc "Command Line Tool to help format Swift code"
  homepage "https://github.com/Jintin/Swimat"
  url "https://github.com/Jintin/Swimat/archive/v1.3.3.tar.gz"
  sha256 "6fea933a4d96ce84ecd03cf026c8fca7b81fb9a7749d0ca464b8cd467bd2bd5a"
  head "https://github.com/Jintin/Swimat.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "67632bfd32c323efc95827f861af547850b6b5aa17bda219fa01286afcf9d664" => :sierra
    sha256 "e03a5b43235b7449963345447353cab3fff4acc353c53a8ae0cc8215ffc13bf5" => :el_capitan
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
