require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.18.0.tgz"
  sha256 "38286a87ea52dd1de724c6e35ad83cf2e026fd38b9d5bc7b36d3949b4109d523"
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
    sha256                               arm64_ventura:  "ddf6aff9b9ea35d53fca6d6b28176bee700cbfee5a12f410dbcc0fd4636dc4c6"
    sha256                               arm64_monterey: "c408cad6eed75fd470cd4fec0c8c2d74e4223a9f258da06d532e3a6243fa2e4f"
    sha256                               arm64_big_sur:  "8fb2976e457302e5b00cf236a10b62e2175d9cb5f00b2c05ad71981288d0a56e"
    sha256 cellar: :any_skip_relocation, ventura:        "3b9227731e5ab7d0dcfe6efc68f1e223593260c7ccb29b642794326ff6e571d3"
    sha256 cellar: :any_skip_relocation, monterey:       "1b22ba15277699ab914052a0b6459f9b2cf65fe51503134d9925a0cbc1ca5bc6"
    sha256 cellar: :any_skip_relocation, big_sur:        "feaae78061439c9d7c562bd4ae9df4156915be4a8c2490cb0149fa3e5d391625"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd1a132ab2dda69dc51082fdc84529315cdbf9b3ed616395508fdf4651079f19"
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
