require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.235.0.tgz"
  sha256 "602d9bd56753f4008743c47e39ff91f9dfb02ad8784685ed8d54feb87155e463"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "442268cf429aff248eca438793aff9b5f76791069966c9035b262bcc0a76aa16"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea0d2fbbab361bd44c00e1e957eca0b7286bda5d54becae5ef2812f312a36177"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49d7b6595fa5c9537e04d7fb04893b60b38e23faa00f0c114429cbb2f0a62f99"
    sha256 cellar: :any_skip_relocation, sonoma:         "3cd17b14f366fc5a2fbe24279930b93bf34d0f672dd0e05718134e165a84f6a9"
    sha256 cellar: :any_skip_relocation, ventura:        "3ebce04f3eb9bd5b1281937231d92bc917c7eb043e90e023130334a13094d0b2"
    sha256 cellar: :any_skip_relocation, monterey:       "c3c26aa253160e5de887b9f11236351e6cdfbced6296f8a3a643ef277a2a5b9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23b6278a0e20bb8aa67a31a6bb49e2ca8aa2c1bd5a2e2f0c696d4b8d7e2e933a"
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
