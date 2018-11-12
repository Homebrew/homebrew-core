class Swimat < Formula
  desc "Command-line tool to help format Swift code"
  homepage "https://github.com/Jintin/Swimat"
  url "https://github.com/Jintin/Swimat/archive/v1.6.tar.gz"
  sha256 "44ff6d7642b36ec8e784c1ce1801ad8e9915cda65728e6684f4ca272aee8acbf"
  head "https://github.com/Jintin/Swimat.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "12ffe4eee9c6d9abe8e84abf777f74ed7ab276206ad9f06dca801f4cdbcbca52" => :mojave
    sha256 "fc96c111dfbe508667feb7611c9c7d313fa8409c84d5a98d6bcfd99ef67e76d1" => :high_sierra
    sha256 "7a14a1bb3c7d1b7421b2bef0d24bf23c98375fa2dfbfd866c7bdc9517162bdbb" => :sierra
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
