class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.256.0.tgz"
  sha256 "b0df833c9eb2fa9edd1fd91de6fb855cdbd70cbaa79e068fab9d5b847cd57020"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "297faa155abe48144e18e140f8b9a33ad1ebef84ab1f28e9ad5d69ffb8e6b18d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b09464c11202809d86de25a696effe05a8de566ed58a2c1ef5336c98a093e59f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "070b1a8844712db3dba6f5eb5501bbfce0de775e694c2f0315ba3c5e6d608bef"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd89eec1d58e32c4106240ab2070df8c663ec286c052520f006b2910ab861930"
    sha256 cellar: :any_skip_relocation, ventura:       "02040dc31cec2822526bb5de9d472e8928d2ec3cfdcc143a11b131f62cade324"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d92ee156ea5eb8d131417adbd13df26dab2d00bfb7efd81ef53b4b517e4b589"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01c33e5918e199d174954560c075cc5e5a012ff123d14e85b84415bdda535fe6"
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
