require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.250.0.tgz"
  sha256 "fb841b5d0a83e3a6fb598bf57d15271cfebb615791b63eb29d4d169c6182ee38"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "959fbcfb82aa62061412a7146a8e6218f9b0d6a93cd8b9d080f7cffa802351e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da03ebf7485c064941000918210ea7dfde8166bce0945005f684efeef363d1e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fdc7832c372ba78104aef955071e2f8204fd8557e55fec70ea1a90eb12c754f"
    sha256 cellar: :any_skip_relocation, sonoma:         "9442d8de64aef4a217c0a144e32ae0f4a443ad7c7f0c899c453fbb3c8195d894"
    sha256 cellar: :any_skip_relocation, ventura:        "9c2ba2f7783f8570afbfb8c04ef6770e42f58b31dffe46662f5f2d3860c462aa"
    sha256 cellar: :any_skip_relocation, monterey:       "6ca50e4629ef9d0d1d7cb458a31ed3d94fe358170cb8d2023229f973d79eaa59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db8d0eb8dfd9b744610510ec9117d4be1bc08cf57ec07a9a5e46fbdba284cc8f"
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
