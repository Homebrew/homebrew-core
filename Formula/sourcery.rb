class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/0.11.1.tar.gz"
  sha256 "6bae535f1810a74089a1b44b50c4ff3678dd21988e6c0cc560271a351b6e48f4"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b489be40739a56f5662d814bfef75283a0065f56586b82a7a2e1d2d77c00c982" => :high_sierra
    sha256 "ee6bf4546f5a38f3df6ee3fc220295ced3c4b5cda4e59356d12d1021d7d8b479" => :sierra
  end

  depends_on :xcode => "6.0"
  depends_on :xcode => ["8.3", :build]

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
