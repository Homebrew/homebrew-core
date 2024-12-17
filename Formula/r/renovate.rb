class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.72.0.tgz"
  sha256 "33b8f73e3125763af97ca105cd68afc21c09df970246d137babdf41ebea7509b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9922f78300ce66846cf991b3a913058cdecefede3982743b6c876cb1cb1dd05e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7dc53d296ee5b491db8fd7b307df13eb836b93dcfcd9a441b58a2140abe93bb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7db9172e0d935e5bf6f881476cb9f64a2e0523b10ae7ba62ecc41ddfdad9137d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e21bb4331045c696d366110f56584faaf29ad3b0c2ca74c8deeabd822516a466"
    sha256 cellar: :any_skip_relocation, ventura:       "345764732534a37b880cbf7ab2ec963be4f2e7cc534c13d2adc1d6436a03ba39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4984b438ae60f0c7389934a9ce87128e0965ccbcef6f4d6e3097fc2e3a359f2f"
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
