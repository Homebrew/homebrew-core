class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/glideapps/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.171.tgz"
  sha256 "f33e1c0371aa6d60b37405583be72b16a60d189117cce9b2f4c7d19ab24535f0"
  license "Apache-2.0"
  head "https://github.com/glideapps/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58ae1e2db79f0cd36c5ae3bfc03e62c42ac9189dd2e388ad0809b95568da15f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58ae1e2db79f0cd36c5ae3bfc03e62c42ac9189dd2e388ad0809b95568da15f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "58ae1e2db79f0cd36c5ae3bfc03e62c42ac9189dd2e388ad0809b95568da15f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8933a693ee1464a6d04aa81c15a3cb1b9cc26b4b11ac49794051edd5e27aa14"
    sha256 cellar: :any_skip_relocation, ventura:       "b8933a693ee1464a6d04aa81c15a3cb1b9cc26b4b11ac49794051edd5e27aa14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f70d4e4cf6813dba301436a9996a98355f25f5953942bdc3fc14cb5d2e86aff8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58ae1e2db79f0cd36c5ae3bfc03e62c42ac9189dd2e388ad0809b95568da15f3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"sample.json").write <<~JSON
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    JSON
    output = shell_output("#{bin}/quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end
