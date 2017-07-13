class Swimat < Formula
  desc "Command-line tool to help format Swift code"
  homepage "https://github.com/Jintin/Swimat"
  url "https://github.com/Jintin/Swimat/archive/v1.3.5.tar.gz"
  sha256 "c5c9db2c577889699b48040dbd6cbb0850cf14e946b43760e890728ba8473e86"
  head "https://github.com/Jintin/Swimat.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba55464babba7e8c0998523dcbef81442f22942f7dc70456522fb81b436a3c96" => :sierra
    sha256 "8032f970d92bad803b1aea9a0088de52c4636a08905241e84aa9804b565bf9b1" => :el_capitan
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
