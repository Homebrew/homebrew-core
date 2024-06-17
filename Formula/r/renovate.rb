require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.409.0.tgz"
  sha256 "a4340825c00b4b062a55563c455f7cc6ccdf21f25adfa6105199b33baf40382f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d7b3d91269902eaad8cb66591545ea4859968ffcaaa776a152d3c97d79268ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4f80b13831556b1e4520039495cd1a3eaa474b8c1be986a7b3696ba97a5b9b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "538b28f593de65c78178ab1effd4dd370795879252efade5fd5d3767119ccf12"
    sha256 cellar: :any_skip_relocation, sonoma:         "736ad89d210d111452e62fb2c5f03def67173438173c6dd5cc98eb69688b4870"
    sha256 cellar: :any_skip_relocation, ventura:        "3364e010579a18547804857cc7894a7c06f2640ab7cb83751610a2c92ce3c98e"
    sha256 cellar: :any_skip_relocation, monterey:       "6d87cf1030f7a28dc1e7f6df2f2dac9735fea73ea5e54662ec933c041849a4b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e127b86f0933ea502fde9d7b4055b1654039f5b203f21186643b0ee46fd371d"
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
