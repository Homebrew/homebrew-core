require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.239.0.tgz"
  sha256 "983855093e8663bc4e1f71b3ae6df2b38308dd4c5394831af99b1e9573af8fb3"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e3ea3cae200db20b1d6056ba393ad05e3bb3b2c8a6dcd71ea99592b33aec1a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce6a82386db7453132e148fad075517f7f271459465b3894a06a01b6ffe666cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "479c650091707d9232370c21497b3419de813ff7b7576795f8f9cc5c7484b3c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5cc1bad928e6d3a87ab614122580b0f8acce13d6480b74655bad1c1d1225a7d"
    sha256 cellar: :any_skip_relocation, ventura:        "503f1904bec603831930dab18200ee85912b8587e116b4f66993f22855a4109d"
    sha256 cellar: :any_skip_relocation, monterey:       "2c5e01b1099a8ae5e5dfd14e181352e028733d380819a8b1daa346c86465196b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b9d458683418a7263964e5f75f14c332be70298f285190f415cb8e8bcd6c76e"
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
