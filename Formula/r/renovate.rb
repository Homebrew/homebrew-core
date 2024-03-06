require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.230.0.tgz"
  sha256 "0bb4600aeb2ae25111333780d1039c3dcdc7b22dd51de345b6c29f8c2f704f65"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6563cba248fe877c61c928c869ce4afd040903cca0910c2a2c56a036d6387ebe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4d7589a17d4bd24d7cb6f1c6226e1a5f71669b76f259cd6d4323fb8e362244e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d200ba36ffed65fcdb15583ca907260f7b61a56becf37ff74448ddbdaa067a33"
    sha256 cellar: :any_skip_relocation, sonoma:         "0beac8319cd2efed20c6c608e06f6d777a9485d9d4a0ee52c02f5f773d91bb6b"
    sha256 cellar: :any_skip_relocation, ventura:        "9acebc63b73741c7bce807b9dc7870e9476ad0d8fa457bdf58dfaaa4eddf8acd"
    sha256 cellar: :any_skip_relocation, monterey:       "2592e0088712d2dd2365f3cb11afd9602005553b5125d8871bb314b8bea1d57b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf3c68eb30c5144f239a924481b1aa151cdae3f008ec3aeaa1c7062f15d23add"
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
