class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://app.quicktype.io"
  url "https://registry.npmjs.org/quicktype/-/quicktype-26.0.0.tgz"
  sha256 "55de624945e4f04fcc6d64c3ed6fcf2d1d6accd958e13c028deed8118b310c16"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eed280e7365d282b5441b951336fe330eccc59d91f377df5bb394e64b08bdadb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
