class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/2.0.0.tar.gz"
  sha256 "947d4d2758528ccca77de0f4b528365e1ce77e917a4af810afcc3a0328caa473"
  license "MIT"
  head "https://github.com/krzysztofzablocki/Sourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4dadf511fcc95d370c4c1177f6f1f547ff8d1acf3a75b219ce92eee41548b78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3a1fc5930c78d1eb84c77d46f27c185fcfa17fbb54bbf6428d78ed7e27f06b5"
    sha256 cellar: :any_skip_relocation, ventura:        "7fafa2119619a9617a3d5aec4810162abe83d8544fb7ef88daae1de81b358e0f"
    sha256 cellar: :any_skip_relocation, monterey:       "cedcb7105cff45f157063faf89a7a61c973031dfe481e3d8abcad11dcc6db963"
  end

  depends_on :macos # Linux support is still a WIP: https://github.com/krzysztofzablocki/Sourcery/issues/306
  depends_on xcode: "13.3"

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
