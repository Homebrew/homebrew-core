class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.254.0.tgz"
  sha256 "bea2c5d3666770273e2ab99bee6afce9570b3d09245cafea4c58c022f8f4e10f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fadfc746a1ad0cf9129a674e2aac8bff7ef09436c2e1a78d96864b1178c29c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf463dee5cc58d86f53684abeeccca64cdac475f2b950f824fafecda7e95be5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4aa02975a2a857649c0ce5f285047458b6a211fe230acb3b063b5921005280b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f27d077a7870f15d97c6ff8758525e0e96f0606beadc3624ccf838f324f7e242"
    sha256 cellar: :any_skip_relocation, ventura:       "4e95050f0739ae76b235d5cbe3059ce3ce149d9a343ad9b56a20a10eebcca660"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fba2cd5cc7c65192c73cc73a635e3ebd0bf72e5e2589bfccb9a22c389eee0cd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5865a751757f48465694885e704e465c8873b04222950323c366912421064c97"
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
