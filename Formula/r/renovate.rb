class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.30.0.tgz"
  sha256 "d91ffcf4b55b9c0a57d6e1452c62281d043f3e85f19a45cc58d3ab870bede5c2"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cfa1fd340ff7a570642086bed378330d80ea9e78236552422bebecf2f89d40e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3828ec38f69369c7f938b1892e90cc620bff3d54b141a059b2bb7bfc551afb75"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b3c06e7f747c100ee012982a900012c827133285c497054c87a9ae020b794d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "a93bd2e2df4925392cf7e6edeba144852c2a5e216fe0b8df071b1e8e377cdcf4"
    sha256 cellar: :any_skip_relocation, ventura:       "fecb371dda77c52ccc0329968fa3fe5daaa6e2e3a986b194f9e7d6942c78c90f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "faa6359c4dc9d7e05ef8d9907e1a455a28714471a33d26f753ba730f5f995013"
  end

  depends_on "node@20"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
