require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.266.0.tgz"
  sha256 "4d0f2f967be54fa776a2cc3277d69f4a60fb0aa496b9e4db1d3045797189ca1a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dfb66f397724657760eb8ac5f7a5b62b2f35a177ce97d3947be01d69742f5df3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0171ff774e2c0d9ca7f574f2fb50230ecf127db6535a866d7f9d9b5977929b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "171c185c52c308492ed643e9a8d44e1b36282d782ade0170ced6bdca0417211e"
    sha256 cellar: :any_skip_relocation, sonoma:         "bfe5663e476a0bcc513d2ffc4e600bff2739292f93f30fc366af15a39069c2a6"
    sha256 cellar: :any_skip_relocation, ventura:        "46241a1e7882f80ec2cd95638d1f05724d29226931bc22b3c98c08696e426af4"
    sha256 cellar: :any_skip_relocation, monterey:       "2d2adf65d2ec6da7212bdec4f53e7084963c991458a64cf03f1e153cfad80f83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76a704ef841fa0e9c66afe11f802e69e810d1186f09015eabb6398cba9337d05"
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
