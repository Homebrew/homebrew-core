class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/1.3.1.tar.gz"
  sha256 "44152bd6b46943b80415c4679c3beddf923f2863e015dc13c533f6137ecda6b4"
  license "MIT"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "328a5e296643bd6fac05b501cef3e02d0d9c0683446efcf19754945aeeb838af"
    sha256 cellar: :any_skip_relocation, big_sur:       "f47a9baba10d5395c2c5caf764382fd57d15e7761b152ee6bb230fbc32238d96"
    sha256 cellar: :any_skip_relocation, catalina:      "c6a59fef12cb2ba7c12e847dfa311e3f1564d3d72fe6224f74de36fca37642fe"
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
