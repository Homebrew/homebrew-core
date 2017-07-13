class Swimat < Formula
  desc "Command-line tool to help format Swift code"
  homepage "https://github.com/Jintin/Swimat"
  url "https://github.com/Jintin/Swimat/archive/v1.3.5.tar.gz"
  sha256 "c5c9db2c577889699b48040dbd6cbb0850cf14e946b43760e890728ba8473e86"
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
