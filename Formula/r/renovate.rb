require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.273.0.tgz"
  sha256 "1084103ea017d69b4b7eafa81571aa1733ffa8b8c66cddaa4f61fd01661bf062"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29b047846c59ef50408c4ab136e1802a267da8f884b34663370c1713ef0f5b06"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b04e1051bf830dbd612b32f0312084dae4dece7622a1cbed046bf1b3362ae346"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9235fce1863bb1a6cf9642a7b9f5af7b54ef91d0d9577176ff21168df9813b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "87d150445e9708bd8b5288c4b7b91f2fa29bbf9d0d1de9bd5ed253fa45139a0e"
    sha256 cellar: :any_skip_relocation, ventura:        "24a4ed6c28116c16c4a4f58e4c260c5e4adbd9a89280bbd32ffe9deaf24d5fc7"
    sha256 cellar: :any_skip_relocation, monterey:       "5c0643b4d0511ab2bf707c11d345ac8e7821da71646f7f4247c98d6f5fde553e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "faa5cb04cdc829eae95c745a5cc0af4a88412389433319f35dc66aad61b47d99"
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
