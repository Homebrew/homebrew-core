require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.8.0.tgz"
  sha256 "892b2e00c2cb3b18566a4c60e17b0aae5409db3b7afc0aac8c346eb214f2cd18"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c7912304eca9d4da3390204f6f1d9cd4d07fd02983564c99ffd7881d8d44ced"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7276f1872b97fb489198a9e63bb59d2053c2a3fe4dc942edec96c8b322dc1bcd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "441d676b333d1288b535511ac3eb4ef1c33a6d96507ceeb3d465c8f30d31fc07"
    sha256 cellar: :any_skip_relocation, sonoma:         "50da7e159c10d78595eac4dc89b52df4f633b94027071d9ac6fd8af9703e9eb2"
    sha256 cellar: :any_skip_relocation, ventura:        "a01c9795f5c059b4be0f6b4d93581156c2fa6d5c628d89b292feed1600e4a1d6"
    sha256 cellar: :any_skip_relocation, monterey:       "c18b6bf287a79320ca20279f6cb92ec984e9e47f65972e9880666b8171c5e80f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a250c6448326ae7fb30bf2850d6cda013ebdad5ce9b0cb7c5b95e0c1fb7f34b"
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
