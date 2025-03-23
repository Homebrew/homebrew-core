class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.211.1.tgz"
  sha256 "bb9ebffee6b48b2a4f9b0d8efb74ccef35a1220d48a78d9a6e25f50f4a8db1c6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ece4ceb0fcc0e926258c4a80407771eeb38920e4f43e2657a556a4ed25b3879"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67343e132c7a1006d74eeb17792eca8923f1caf98498eff8be8d7090c40cd87a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63ed959e26dfeb3d9883ac17db7fd37cc024d068ab31682f58108584ea8e8f17"
    sha256 cellar: :any_skip_relocation, sonoma:        "df7123a35321161840baa15c035d4eee3d41c7bafbded7d88a76c91bfebeaedf"
    sha256 cellar: :any_skip_relocation, ventura:       "78d7d0ec1d6d33ba4125f4a58f2c5eafffb0eda9501db32b338198d73f725357"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8a10f56af3b274c126a7ec7a1d12fa4dc03e4d778411dc7fb754ce56dd2f9f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff37ab77d0b53a0d9d262a18455f366d6a3c04832912fec64020daa48fcf8ef0"
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
