require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.264.0.tgz"
  sha256 "9faa5ad20c1cb01ff11c456461017713beba6c8350bd477c5df4b685b0424b63"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "259b44fafa9f81413252f25dd18fcadfd0d88e113001ded1656c33964f5fb452"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "041889a466b2e5f79759dee449b9efbf80923895187ae77f799733bdaf9d724f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d511abdab73d608f16cc1104edcfc84ffcb523e0a82b67b98b425f58a1c4cd18"
    sha256 cellar: :any_skip_relocation, sonoma:         "4119155e148f8365dd2451d8ae0d7d0c6d07ce8e57b2e2b5b1aaee2041f93273"
    sha256 cellar: :any_skip_relocation, ventura:        "56b76dac612b1987dd70b287465b59294fd047601267002461c631246ea44fb7"
    sha256 cellar: :any_skip_relocation, monterey:       "d179582f80368df097e2b309ab69b53388cd10444bb7c6f5b0b21a6e61231156"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12d511399bb53476b89936a2f203788db6a5671687092372cf5faf2de8088c7c"
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
