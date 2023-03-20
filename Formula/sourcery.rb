class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/2.0.1.tar.gz"
  sha256 "bc28b9b0392b91e7787ca7e4c02e16aed11b39e940e8916e2c0cf745b1163fb1"
  license "MIT"
  version_scheme 1
  head "https://github.com/krzysztofzablocki/Sourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2294884b53e26e9040a35b5842b9fab833bf7d085301646b43b5f23d67e9ff0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e21e951afe2f588cffa92980bec467848fd51bc1a4905a1530de0d5103ffac91"
    sha256 cellar: :any_skip_relocation, ventura:        "5d0e610493b3319e835278ad6aa168d9d6948b9c95a6d9480d7614ce801019c5"
    sha256 cellar: :any_skip_relocation, monterey:       "32c5987a9e50edcb95904a122cff649c10978e0b99a540dce8c2e91cddc219fa"
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
