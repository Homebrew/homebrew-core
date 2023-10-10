require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.13.0.tgz"
  sha256 "0e7d0305801a95c6a999cb997bd4fd153bcca9448424ed824deeff957cea7247"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ebf717f178927bb47330e66edd1e76fb8b9d020a5d365625b27b7f6fb4623dbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79efb838481ecdc335fcf630d7ce7677a0dee0c265d365cbcf666854cc0ca7ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94f50e3656a0923752e91305f35b1b8147141ad08c90243e72fbf898ddb9493a"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e9af55bf38b36fd87abc7288e3f54425ca523c65bfbb62d764e1625f2d41010"
    sha256 cellar: :any_skip_relocation, ventura:        "81a2707ee30c82f78098db98923f65c7b104b48941316297cca7fa18244510a0"
    sha256 cellar: :any_skip_relocation, monterey:       "d1f2609e12beb1324c5b28a24c4311e77400e7ee94f528e177bd902c5e2dd91f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "793fccaac8d13bc95b217fba73e8d3f680b4861f6ca68f7f417b8b466a8f7823"
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
