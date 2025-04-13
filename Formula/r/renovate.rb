class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.240.0.tgz"
  sha256 "9649692912ec297c3fa564c6165f6f08efd9e6d32296876fe2c4d5c6ce7a8b95"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4ccafa86b10872ddf9f34e4445a010b36e815b7f321911eb729c375e8a55623"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f6e9bff52f1ae53a1e20c0f4537565f2c8a33c192db19811ff8e249736f1fb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e08c238ec6dc18572f8fd899ecc5935d29ef75e9b74f437a0c609e987c0cffb"
    sha256 cellar: :any_skip_relocation, sonoma:        "39cd8a477828ec42bcd170c701c3693279799d572c04556b6592ebdee0b7fd07"
    sha256 cellar: :any_skip_relocation, ventura:       "355201238b01655d2251b6d22c261f9bcb8711afcacefa349999590a8902b8ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3810ad0f7aa9e1ebe1ab5705ae243b95131b9ac22892d4887fced8bc19725119"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8725486111f5d3c7d2981d6725e18753ab49f32b6be7581a163974daa8d7213e"
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
