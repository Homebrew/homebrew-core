require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-15.0.100.tgz"
  sha256 "ea9ff46abbacf6c2969c8438e83f5eb1fb71b56c4580721d63cfacbb6273d56d"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c54e23a2adb0af9e4751717fb0125656b964369d42055e1f8b0c59c84649324" => :high_sierra
    sha256 "e6ae6d2e6ed8152f441ee86c8887b9646fcf4ce846cf3ddb8541486b7c867585" => :sierra
    sha256 "4a2f95ffd4784b743d80c8a41a70dc72cc3f156c4208f399807cb382e16947cb" => :el_capitan
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
