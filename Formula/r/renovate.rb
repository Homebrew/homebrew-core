require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.108.0.tgz"
  sha256 "ec80cdc681e5c14d1a5464827c9e7884803c55decdecd9e8b2088494d0876a5a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "095e5a4545bce7d2113a357a94a156b4e8e321fc74dd409fe365af5bef6003ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9c20a1ce22297d22877a7ad9cc79da1b485ba57cfe81c54290f8d7b879cc7a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22f853190edd96a8f42fa9650157e1e1daa499657f45e56dc71ad9ba110c9683"
    sha256 cellar: :any_skip_relocation, sonoma:         "88abde5d7e981b8e91f4160d6c11251cf52de085a7d718642b1846374ffb05d5"
    sha256 cellar: :any_skip_relocation, ventura:        "866f68b026adf7a03100665374b7d893968c4ceefd361d16021285f201a01fe7"
    sha256 cellar: :any_skip_relocation, monterey:       "4d816ec33fe6712f10cd003143cb49858acdcab8f2dbc2b223f93e97ab4f7f40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34fc949c843833cfc99a1119bb369814547f78cefe5367d533ab7717f44e3dcf"
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
