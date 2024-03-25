require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.270.0.tgz"
  sha256 "81f1164e43d8626f578aac63cf67a262376dd2ced4ba5571f78fded6eb180d93"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a2dcf3c0f544264502268ef8b6a65ea406f4d080c04e2f37ad3c2a85030495e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3979d6f0944290f2520e504e99c496e91971429237dc99707c86cc9003b62237"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3645fc07510920eccb159b92ff71246ab77d134110998daafee76d1e476d9c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "537c82f58d2d235e1f452ed9c126c3d9cab3a45b885fca608378292e49cefe41"
    sha256 cellar: :any_skip_relocation, ventura:        "5dadfe873b60def6697058687798cb0ee4a7e9efe89ae381cfb531e6a339575f"
    sha256 cellar: :any_skip_relocation, monterey:       "c68fa907bd97a677f09c93e6ef670bc01b454a0ee1b9ab29c0140eb764d82776"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61e038e0dba2583a357bb604038fa7de2c73f8ef609542a55a3886f9c310c7ee"
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
