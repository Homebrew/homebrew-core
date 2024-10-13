class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/refs/tags/2.2.5.tar.gz"
  sha256 "6f4d4d2859e57039f9d49f737a696d0f22aecaffd553a7d5039fa2007103994f"
  license "MIT"
  version_scheme 1
  head "https://github.com/krzysztofzablocki/Sourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8de58d41945fa3cdafdb4e7d9d3061341eaa4a3cb2b8041b0dadd3ac7da98ae2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e165bb8f38cae180d1a8ab72536ef975fc86f393e557628774e2b9c95a5631aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "103a047a9d50f0c1e885519efc6b3da81cf98ff4ec085409ed33849aed0280de"
    sha256 cellar: :any_skip_relocation, sonoma:        "291c5eaa8a32e96009ef0f2186f7a694a3e13b39c7ff4f885b9dc0ec0444f8ee"
    sha256 cellar: :any_skip_relocation, ventura:       "6cf466dd837f0b74ce5b02d0a0312ef7aacd4819ba995b23c4f72f82d68cc098"
    sha256                               x86_64_linux:  "9007a49ae37e68433784b9ce2cff0fbabb7526c114397727935ec8dc2228c36e"
  end

  depends_on xcode: "14.3"

  uses_from_macos "ruby" => :build
  uses_from_macos "sqlite"
  uses_from_macos "swift"

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
