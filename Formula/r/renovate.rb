class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.119.0.tgz"
  sha256 "91d6bc5ced08085153f9bf082e78b681dd4c3e97b3981fd723cbd632cc8dc6f1"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94565fa1751893a17a774baa7ee4e65840a70b371b52b723f057d10d8e30f589"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b3ebf3e75e595dc2e2f4f5bc6d95d8b9551846fb3b685fa08cefa02b90bcf08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "693b1c9cb848bcb109e3b68b34293e2d9bb7b57f6f63d5e2d0a5c38d4236495c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ba62169b1a5d88fab9d1d365a690af22abc114cdf1d661a30abaa65135c8a07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b1130014499c2d392eba1abbafcda1110ca94f3b7f6c3dab2d41201e0eeeeb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b18e6ff3ed87a4d66f9e335f72fe935445338a6ab86985c2b695beb9b6faf8ad"
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
