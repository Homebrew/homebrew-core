class Swimat < Formula
  desc "Command-line tool to help format Swift code"
  homepage "https://github.com/Jintin/Swimat"
  url "https://github.com/Jintin/Swimat/archive/v1.6.2.tar.gz"
  sha256 "1e6000dd16857a769070036fe710dd0b2aa6c4436a02ecc60590d829d6228e8b"
  head "https://github.com/Jintin/Swimat.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "12ffe4eee9c6d9abe8e84abf777f74ed7ab276206ad9f06dca801f4cdbcbca52" => :mojave
    sha256 "fc96c111dfbe508667feb7611c9c7d313fa8409c84d5a98d6bcfd99ef67e76d1" => :high_sierra
    sha256 "7a14a1bb3c7d1b7421b2bef0d24bf23c98375fa2dfbfd866c7bdc9517162bdbb" => :sierra
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
