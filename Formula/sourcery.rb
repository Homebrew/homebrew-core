class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/0.17.0.tar.gz"
  sha256 "f5a273cf1f6c5591e40505618b8914d8d536b3e345a681b974b58a92920d514d"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "44f4fcd37b3694be58e5770446ebe08d7e39cf60dee8816a2aa362079dfad8dc" => :mojave
  end

  depends_on :xcode => "10.2"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc", "-target", "-Xswiftc", "x86_64-apple-macosx10.11"
    bin.install ".build/release/sourcery"
    lib.install Dir[".build/release/*.dylib"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
