require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.26.0.tgz"
  sha256 "d1cd9f61e7dc49d4c6b81c03133f50c6fea4f243fa67508a9a78542df34a2a5b"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https://registry.npmjs.org/renovate/latest"
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfad075a73a4a0f95fe0875c0925fcad9a914329684f507275f85233c11063a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24e267b68c9fb68a23f7468cfca4a09e08f059a69a5cea82b6cf4db3cb825420"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "345ef368ca3c20ba3d3e1649c3d8d25f5a794fe2dce035a8a47ec9ed788881a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "c03e95a99da150faeaf5e863a07cb7d65471ef4983538da7b7e922b2a69e840d"
    sha256 cellar: :any_skip_relocation, ventura:        "82af003d7913fcab32ead9719af29e70cc982bdd092e7455663020247b49bff6"
    sha256 cellar: :any_skip_relocation, monterey:       "b6e7fa1822e3454ab742dd421dd977900d32e6a50e0c74dd001d8ad15077e493"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b91ad39774ccb457d26404649272fe841803f9cf6e818391a6b2e257232f6e52"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
