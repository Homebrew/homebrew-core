class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://app.quicktype.io"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.3.17.tgz"
  sha256 "4543cba17ee1abbc73ac7178f2eea5efffc8392f3b16245ac4976f5cf4c485da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b099bea6d70c823ee3bb401560c91205eb6627af07cd40c2627a621595ce8cac"
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
