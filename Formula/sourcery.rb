class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/1.3.4.tar.gz"
  sha256 "12569a13652b918c066c3f1828551398ca0653d9318946242c412bd93c16adf2"
  license "MIT"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1e9a57e73c921a2a901e049a19676faa281774d40e19a078f2b306272c975087"
    sha256 cellar: :any, big_sur:       "5a67b8db6b4ac335a969b0f9bfb84beabc930b1885fc88161b9df7dffb137333"
    sha256 cellar: :any, catalina:      "328af5def654b4e29fb3827c6e5ae64f9e0b6ea191108831dcb48f000c2f90a5"
  end

  depends_on xcode: "12.0"
  uses_from_macos "ruby" => :build

  def install
    system "rake", "build"
    bin.install "cli/bin/sourcery"
    lib.install Dir["cli/lib/*.dylib"]
  end

  test do
    # Regular functionality requires a non-sandboxed environment, so we can only test version/help here.
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
