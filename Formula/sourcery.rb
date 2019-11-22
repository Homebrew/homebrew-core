class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/0.17.0.tar.gz"
  sha256 "f5a273cf1f6c5591e40505618b8914d8d536b3e345a681b974b58a92920d514d"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c4eb5dc81504cc26454f150c979435373c8f4c841053961d38a5a4ab74af92e" => :catalina
    sha256 "e8b4ac7bc894f3889c6a8862b9b71344b51f4abaf08704f44a04a62ff95aabff" => :mojave
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
