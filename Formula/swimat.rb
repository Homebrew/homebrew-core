class Swimat < Formula
  desc "Command-line tool to help format Swift code"
  homepage "https://github.com/Jintin/Swimat"
  url "https://github.com/Jintin/Swimat/archive/v1.6.tar.gz"
  sha256 "44ff6d7642b36ec8e784c1ce1801ad8e9915cda65728e6684f4ca272aee8acbf"
  head "https://github.com/Jintin/Swimat.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "62540da0e5888e141f394a38ef655b32dafe69f6481d201852ca979ddb28753e" => :mojave
    sha256 "a333754bfce58f5d9de855afbb47bed72e2f3a6df1382a560598e3cc8fc0f8fe" => :high_sierra
    sha256 "b6900b8712d237bf704bb1c0b218beed0e0d790c290532f6fc806e033105ad8a" => :sierra
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
