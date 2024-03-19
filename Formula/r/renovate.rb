require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.257.0.tgz"
  sha256 "2f5a18ea04e05d48c427ceceb213cb03d8c21292c4f1fa12aead02f2e47d348e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94ca3ed1a47684b6cf219d796a22a4a84d1c054d510cabfdcfccd70bec6c0e94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28c212b67820e88014495ca993b8ff2dadf586f219f6facbff98d7c82346426c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6becc46d1bb28611dc06f9f8007fb19a38c9bb0325d148f0317c52bc7b602535"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca8835e777826304b4237e6b9e44d9144b52d57f4be02fc47df64f1b74ee2de7"
    sha256 cellar: :any_skip_relocation, ventura:        "958ecfa2a838adaed8836019bb58acc02b036a5fc378decd1120ea3c61570844"
    sha256 cellar: :any_skip_relocation, monterey:       "a265904a713f539be376b8048659c08b7217a77c9203b7dc8338cbe1fc1ff60b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2e50e30627433a092ef31b5504470cb4012b9d7a29fa6f54aa76bb7e3891ea6"
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
