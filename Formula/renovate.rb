require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.78.0.tgz"
  sha256 "c79b5d7dcda3f165edae12a3f06bb9c4dc0bebb492ed635c4c56a5ea3bafa597"
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
    sha256                               arm64_ventura:  "e970f73efa03c4d1937bbf071dea4e7b1d60b47e7db5fe536f9535db4e6b932d"
    sha256                               arm64_monterey: "37898ba8a0884f7b8a0b869a1cb8d00079c167296eab6c35b912f5080f9e7221"
    sha256                               arm64_big_sur:  "f87a2ad986ef9b2a922f3395343c780ca5cd1f903858e1736ca19b2a7033cf3a"
    sha256                               ventura:        "eecf37817ff70e45a797643236b952dd75444cb683e99fbafd9a18a933fd58b5"
    sha256                               monterey:       "5c68fa0cc747c98549716673bb2910bb0ecef3fe0f8abdcbc023872354317def"
    sha256                               big_sur:        "aeca3f9856c752a43c438e6017118b09c5127043a169ce305c974bf128bf44df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22132272f97396117ab589e4f1633fd3c0d35e936845196690711966c097bffd"
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
