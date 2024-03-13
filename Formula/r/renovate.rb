require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.244.0.tgz"
  sha256 "aef2e3059e18b5a043ef8614e13bc01882c69634935950f770923e95ddd6c81a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72b9d221d6a4ba3339cf297d3ac9bd720a03598f298a749aa4f7608751872404"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1b94f095d92b451caaa3ded937c7795e0126ac4da0cb5cf82898030d312511d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fa5d19d1148590c4b1d7e57500e46dc1cb7209020e83a495d1e25344703763e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f31d7b77135067d03cd3145a3f41f440debcaa0b0817159081d5ec76ab64db5f"
    sha256 cellar: :any_skip_relocation, ventura:        "b9673372a95e097cb43757c67325ac2630caa8aab9e8fea5ab541ed75008495d"
    sha256 cellar: :any_skip_relocation, monterey:       "586500fae43bf722cf732b8c61225d9c3c37b924be781021fcd857dca59d09a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65b2416488c5af31c54dc3739f383fd7a96a8ae7a1614136d4f4551c32748aa2"
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
