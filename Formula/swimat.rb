class Swimat < Formula
  desc "Command-line tool to help format Swift code"
  homepage "https://github.com/Jintin/Swimat"
  url "https://github.com/Jintin/Swimat/archive/v1.4.0.tar.gz"
  sha256 "5ff76cdb2a51763dc7ca9a5a9c3f76f5a2d313da7a630dc55ef4680792a622b8"
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
