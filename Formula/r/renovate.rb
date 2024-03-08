require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.232.0.tgz"
  sha256 "72e979e65f7f4c9698b384647ca285dfd1246944ed7576d7dee3edef888099ee"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05f312f60fd5b2ef80aa09413571fedbbef04326f6e824029783f01a526d7cb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f28cd33ef9a642c7ed9434a758e924c72d53524f0a5dc77773b205b39b2231fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "656c2a72c7ad9b8e70646d918d02825959ae86d840c773cd690b4c14d017a43c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8d1140cb5a1d3d11fada6e5d070759933ca2e861c55cc444cbfd33abe9bb682"
    sha256 cellar: :any_skip_relocation, ventura:        "e440023904974224730feccb7b388f6729bb5e90c564404199156b9b6ac47c0e"
    sha256 cellar: :any_skip_relocation, monterey:       "7d7d5ff21482b154d5851ad23721a93320f8bb61b4c2ba712b2a85bcd56fc288"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6f743800376f38a35a05b0bde2f552f748532f1af97d5a5edae75520ebaeb73"
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
