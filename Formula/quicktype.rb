require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-7.0.0.tgz"
  sha256 "371fce10f3579b92bcc9f88120fddc6615a5fcc066a550eef0793d5ccad38bbc"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec31e64fc9c2f283dd630ecbba71a4886b19c1d23507116919963aaebcf38091" => :high_sierra
    sha256 "f8696d5d7a99b0533de639236e99e9c28127d1b05c0a87b041245a22bb6222cf" => :sierra
    sha256 "47892e00d8989262e80340c263e31a7143749431f6f75356ee2d5275cf43166a" => :el_capitan
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
