class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/0.16.1.tar.gz"
  sha256 "2a015af9e501eeabfae72033e91620365c1ebdf4dc401ae2971081d479b6186b"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "52aa9c93e74d1ef166bd94e7ffe64cd1d84e32be022ca4ad06e033efc2302187" => :mojave
    sha256 "d7ac927eb11a3dcde8d02deb190fcd9d80d70fcb8c9038b253168d2958f80380" => :high_sierra
  end

  depends_on :xcode => ["10.0", :build]
  depends_on :xcode => "6.0"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc", "-target", "-Xswiftc", "x86_64-apple-macosx10.11"
    bin.install ".build/release/sourcery"
    lib.install Dir[".build/release/*.dylib"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
