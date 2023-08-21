require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.52.0.tgz"
  sha256 "d5cc5e7265c7d9335bbcd14a071211ad958c7801ab2fdab5e0ccd7c3cfb1520a"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e984103494f3f78936f0e00b53e43f5826dc9ab0f1cfbabbce6040fdf8e7e062"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c559d94b57297d99726a8ed60d2d1881a367b7a58ea9fac415e34501e2cb332"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6de9925ce3c62efc57a30641453be1249c99bcf654c1016d114b674659e45e58"
    sha256 cellar: :any_skip_relocation, ventura:        "a23d47e2bca2f164cc3837e65a526afd382b0593d4bab9d53f74514ba522b780"
    sha256 cellar: :any_skip_relocation, monterey:       "e476bf1887fe69a2c5223c1745c7cee2b1ee4c6e721744a22b74a0ffaa6157e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "420376966100c7302f44273e2490cc49c035975772b188e67b207dd9aede2406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4c89e187bcee5a0149c8acd5a2d322366aaf7a106f2668b4f72c823b3c21bff"
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
