class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.125.0.tgz"
  sha256 "706bb4e3de07548fde0371c2b651270dabd945ca8fdf6722d98c97d4646ce4d9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e475a960b3c9c2c5964c3edeffbe7507f6ddaeea60223474a367608ea1697c81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06064e6f259deaf8c0c3973415a2d0c9982519c7c41b343d56016fdd2aa5f80e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afb37256bf4e3b780952a10b9ada491a43cd24a28e6862246ba1db76eec6725c"
    sha256 cellar: :any_skip_relocation, sonoma:        "98b7f8171940c26eb68fdcb29bfd1b837d7d3fc86dca766f85310e68da3c2765"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb8e7422dc0395c9bd2e6b746a5b3ccd837f2fe4c4369734bb161cf2d5f919bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be8aee5e090ba14b3f7958606b9e3ffb01412826e24cee4ecb035b3a7addfc8b"
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
