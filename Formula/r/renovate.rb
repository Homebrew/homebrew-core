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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7743c0bb0a7cf55d162769ed0a6c6c789dfc321f95e5a9b27727a98a65519a71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c9bb686ad48a2ea752f962f94656458d779280c1b6877f562ecb15c935b9c38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69b8b58c53a7a6aed182830484dfdbf4636ce303690bc3a113ba536df06025c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c5ba7abd593f2e5a1e650fde2ad4d7745dd62145d88f77a338f87db99bdc469"
    sha256 cellar: :any_skip_relocation, ventura:        "4bedc8ee85194d03e19104437912921b708c443a85adb09a2d9d78afb7818047"
    sha256 cellar: :any_skip_relocation, monterey:       "1fd3a5cf3d5850d1e28dc837106760cbaf41f94e34639b1276f25af106d0e9bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4e54feed8b3e57d944e21d56e376c3637f60c5b1a7d47931f0a05f349003644"
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
