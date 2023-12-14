require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.95.0.tgz"
  sha256 "e9cc347d335c5dd85ccf2a004b25959317665b2d240769bff78155ee009e6843"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b9fa9391e5c264b6cbc2123e2826fa77c72b26cd1d6df14ab7b772cc351edaa3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b5b060eafee2b36e91d95ef0c13d568d419b514eb0497b8319e6b6a4c969e60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72f3d0a835949603eacc44827a9622e19d6d2f41189e770d004e52666d8f100e"
    sha256 cellar: :any_skip_relocation, sonoma:         "ced00793eed63e5d2c44a5d96959e1089f53f5488dbc6dd0a22ae919d8f9f1da"
    sha256 cellar: :any_skip_relocation, ventura:        "350b6a1abd12e3a169f38260b98c95354262dd956c5a659f5c95f56f43a7e045"
    sha256 cellar: :any_skip_relocation, monterey:       "88b29883b4fdcfbc2c1fc5e3c6998af604103de70706bc2199ebd5b7b066d26f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d105c3128fece51d58f3eb9dadd0cee331a266eae194f420d531fc7d119a690"
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
