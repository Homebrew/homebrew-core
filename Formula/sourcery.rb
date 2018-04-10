class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/0.11.2.tar.gz"
  sha256 "0be23addc7ae986158cbef263393539f9e07f67969a1d51b82aec78cb7d0d21a"
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
