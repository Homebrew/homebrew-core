class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/0.10.1.tar.gz"
  sha256 "fa27c1aa820b1df6cfbaac5bfe07985d4202583bbc44f9b4ac6ab474e02f70e6"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f85a4ba19bf64fee74a4a5ca32b6fec0c06e0a489f91ebe65bd79bbe5c2134d4" => :high_sierra
    sha256 "faa08e1d1174909d70aa739a96539e2aef6209a4430d518220b4d46f158275f1" => :sierra
  end

  depends_on :xcode => ["6.0", :run]
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
