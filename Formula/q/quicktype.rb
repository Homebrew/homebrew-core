require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.145.tgz"
  sha256 "573910897b8fd49cf9b520c9241fe9a333946d43ab0db602b547fe8866673e16"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2ad56333810883bcaa2300ee57835bb4369f43c959f1b04d4980c81250152ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2ad56333810883bcaa2300ee57835bb4369f43c959f1b04d4980c81250152ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2ad56333810883bcaa2300ee57835bb4369f43c959f1b04d4980c81250152ad"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c358606e576a2a646d7352bbbe9a242c72ab458197a53c206a4d36bec3e5676"
    sha256 cellar: :any_skip_relocation, ventura:        "3c358606e576a2a646d7352bbbe9a242c72ab458197a53c206a4d36bec3e5676"
    sha256 cellar: :any_skip_relocation, monterey:       "3c358606e576a2a646d7352bbbe9a242c72ab458197a53c206a4d36bec3e5676"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2ad56333810883bcaa2300ee57835bb4369f43c959f1b04d4980c81250152ad"
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
