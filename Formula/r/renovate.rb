require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.214.0.tgz"
  sha256 "44a3033512f2a97164d7234db52407e4bb479c0c47db1f7e0842e2c8aee66fd4"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed03b7b7a146e2c2cafea5b58af5b567ea21cb158b2b9aaa9c1a8a61277cf400"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c93451caed950cb63450dffa60180492c5daade28063b9cbf52775d9591ea923"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c50dd9d42935a3cd11b83f77dc602f6d124d2660bee919f8c010fe91a83e32d"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ca6289fbccab00fd2029946d28f255aef9d44bae6b81c505efe0267754a13a9"
    sha256 cellar: :any_skip_relocation, ventura:        "d8b565af3afe891d9a5b6cc197ae9ee5f3f39549c2e51e7b03a45b5584782b17"
    sha256 cellar: :any_skip_relocation, monterey:       "a587c41849561d96c2e39db6417e925dcf05cbd11184628527ee1afd6ad393f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41f5e901de36da3648170443ac38ec692d554d322f63c3cab5c9f12cdb748479"
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
