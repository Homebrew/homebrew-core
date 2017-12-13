require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-6.0.0.tgz"
  sha256 "f615dc2c026a3125039ba4463d8c931a7a771a496366c9aae252512a09a90854"

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
    code = shell_output "#{bin}/quicktype --lang typescript --src sample.json"
    assert_match "i: number[];", code
    assert_match "s: string;", code
  end
end
