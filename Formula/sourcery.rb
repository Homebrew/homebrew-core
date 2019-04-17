class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/0.16.0.tar.gz"
  sha256 "8338f1075770d1bd2b31160ed694011b7a49391fa4d3363b64b6b1e6ada74d1a"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "52aa9c93e74d1ef166bd94e7ffe64cd1d84e32be022ca4ad06e033efc2302187" => :mojave
    sha256 "d7ac927eb11a3dcde8d02deb190fcd9d80d70fcb8c9038b253168d2958f80380" => :high_sierra
  end

  depends_on :xcode => ["10.0", :build]
  depends_on :xcode => "6.0"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc",
           "-static-stdlib"
    bin.install ".build/release/sourcery"
    lib.install Dir[".build/release/*.dylib"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
