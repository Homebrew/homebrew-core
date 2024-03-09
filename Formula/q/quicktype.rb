require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.106.tgz"
  sha256 "c88517d2f5164e17a9e193c7222892731f30345b918198476a75f6aca518d6a3"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f847c468cc1ed3321535815ebf16dd8aa8eb2d371275a48181e124fb310b194"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f847c468cc1ed3321535815ebf16dd8aa8eb2d371275a48181e124fb310b194"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f847c468cc1ed3321535815ebf16dd8aa8eb2d371275a48181e124fb310b194"
    sha256 cellar: :any_skip_relocation, sonoma:         "15809848565980fe3000a7509ec51d61623c4f752d3c2963d459b711f9ff0a76"
    sha256 cellar: :any_skip_relocation, ventura:        "15809848565980fe3000a7509ec51d61623c4f752d3c2963d459b711f9ff0a76"
    sha256 cellar: :any_skip_relocation, monterey:       "15809848565980fe3000a7509ec51d61623c4f752d3c2963d459b711f9ff0a76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f847c468cc1ed3321535815ebf16dd8aa8eb2d371275a48181e124fb310b194"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"sample.json").write <<~EOS
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    EOS
    output = shell_output("#{bin}/quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end
