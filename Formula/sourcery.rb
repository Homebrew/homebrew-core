class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/0.14.0.tar.gz"
  sha256 "890548cd42d0ba08ebc78c182304b956ae3ccc0f6cda9ae2545ace6f313f9817"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7119feb40c5beec48915c953e3e5af7d6614033d731647288d2e91c97f7e1264" => :high_sierra
  end

  depends_on :xcode => "6.0"
  depends_on :xcode => ["9.3", :build]

  def install
    ENV["CC"] = Utils.popen_read("xcrun -find clang").chomp # rdar://40724445

    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc",
           "-static-stdlib"
    bin.install ".build/release/sourcery"
    lib.install Dir[".build/release/*.dylib"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
