class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/1.0.1.tar.gz"
  sha256 "3e748d21094fd8a44b7488a2f969218ba03a532213a2b9c9a80a547dae9b4db2"
  license "MIT"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "520a74dc7e51ac8f09d6ea923c30167b939d27ad7528a256c55a978dc3a76cd3" => :big_sur
    sha256 "18df6fc42860b714ce6f2e31e0c2df6409927d793d4c5594b3e752feae42d6a7" => :catalina
    sha256 "adbafe637b3ffb78250e1ad95514d1c9fe597331fe13e89925381783803bf255" => :mojave
  end

  depends_on xcode: "12.0"

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
