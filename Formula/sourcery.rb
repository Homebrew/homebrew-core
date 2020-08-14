class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/1.0.0.tar.gz"
  sha256 "5947267143fc63504bb21c094accad8c51160834f204a9b108211f28525bfbe4"
  license "MIT"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a44eadcab33192fe80d9a3c487e82448197c43b1d70af1516d425b05e25a5892" => :catalina
    sha256 "debaf5a493f59bb3860806ffc3c9a9fb7e52805f1fc9c84d2c4b42e447670473" => :mojave
  end

  depends_on xcode: "10.2"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc",
                             "-target", "-Xswiftc", "x86_64-apple-macosx10.11"
    bin.install ".build/release/sourcery"
    lib.install Dir[".build/release/*.dylib"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
