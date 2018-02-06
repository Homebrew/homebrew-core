require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-8.5.10.tgz"
  sha256 "9a316aa56eacea0cc2364925e493093f1643ad76d3cefaf242aabe827fe8dbae"

  bottle do
    cellar :any_skip_relocation
    sha256 "4688a524d4ed472a597ddf936070deb77f48a110a5bd30f02d5f3c5745e6e7ca" => :high_sierra
    sha256 "b593ef780e0c48d879a59efb8b0fecbb9d5046964aad8a5e3aa8fbf88f4339b7" => :sierra
    sha256 "114c7d936cb8c987e23fa45ead163bffb231c0cf7f84b55ea30077da23fcf50a" => :el_capitan
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
