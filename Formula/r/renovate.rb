class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.144.0.tgz"
  sha256 "25af1dcde3ba47b088e7017862aa15d1a32c77340d05e77c0feffaeeccf94fd7"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7668186e1ac8c420b0ec39124fba14d1af48d1f6d28910f80683aea26023d794"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3810fe1fb33663b7509560d44e5d1aa9572c67ec05d4762f4f745dedffc6ed7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab44515b8725e897379f95f17a181d43f9bfe9fd67c9bdcf6120641efb8d5985"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f421bf2ce94413fa325351c4f4c3c71f65173e16e00825d8ff01bfc9f40a0de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d67de9f5bbe17261f140eb02d2f0ac2c0f22ee39b0aeacf8a66433725dfe888"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca20411bf4eef4a85e6e677747e090bfe29dc50bc26ed16e98b466db08b08fba"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
