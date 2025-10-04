class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.132.0.tgz"
  sha256 "c0306a29736b92dd40b184b7f5a53c057231066604accc0a9c86430fe0abdb54"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5f4e8f4a282820c3f436a8bac38c5a0293488815b94991af7e5d584003a1e0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90045ff3ca116b20c7d8ef0c6938f3147405e540d61c72402332d93b7cf6a563"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6636790be1613b6713d813a5769ca9e8c89a2857f6bd3c363ee5c417ebf13122"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea025f7243e198943186d50762b711b67c3c0885c7266581a940634f6e040b2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4411b3fc008eb2ef106833fc12e4149ec758f10c0e031ee1b999c1e68f8f077"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c808f988c9609b7eabe16ba9577a8930ef1d4d507127f6d95eac35d05f074b57"
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
