require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.229.0.tgz"
  sha256 "a6417d82ac1ee1c104de69f31c7c5722d79a51956d31e8324eeea66af0ca8a7d"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f24babacc4ca743fd65ca2629d97fa6c0f22d0f716a98805eedddf8f494d2a70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02e120798c4754907516c46324b44280de4d3866ad98a8772cc520cafa927cf8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ebd3fa0ca147a6c13421ee56c38c866c0b0138964071f5963729b81faad1821"
    sha256 cellar: :any_skip_relocation, sonoma:         "af04d150b2636050eeff42a027626e7bc49d42478646c13b9a2c38c6e31fca46"
    sha256 cellar: :any_skip_relocation, ventura:        "46b4a60dd9a98fe5d86fda4f17e0847de874676b4fb118ee0a31c6d37bb99ce0"
    sha256 cellar: :any_skip_relocation, monterey:       "aa64985ac748c5f2bc3db7725fa0ecd142f12c74f1e81bb159e1f9757b2f00a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c921cedc05493a4d3bf66f6307db6b985485e79a77efde5fec4310b6ea96190"
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
