class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/0.12.0.tar.gz"
  sha256 "2b8f4919aea02af61f8f875f0fb33872c0ec1ae5f4c7aebb2d6842c206aff6a6"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "340f1951f0e8f780c87efa9dbe40b6613a6d5f10d668599e7c105b54a47de837" => :high_sierra
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
