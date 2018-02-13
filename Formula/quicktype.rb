require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-8.5.10.tgz"
  sha256 "9a316aa56eacea0cc2364925e493093f1643ad76d3cefaf242aabe827fe8dbae"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f5bc01e5b16ff38da97bcd6e861f0f99f2b3c9d46fce25f5755f88c440b0347" => :high_sierra
    sha256 "8f2429a626c9b87043c74d71f7862f4e688e06bcce03112ed8bada80ddbc1021" => :sierra
    sha256 "102ad37d4a8a98a5338a59cf776f2c3a86e25bcef27d0511b1644225632fa9a9" => :el_capitan
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
