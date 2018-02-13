require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-8.5.23.tgz"
  sha256 "8630adad2e8f3377b9b5a897b6b2ea676369072ddfe19288fe134e08649929fc"

  bottle do
    cellar :any_skip_relocation
    sha256 "82b15c4cde207c16a99556d2cbf49738dea2a5b65cd0cf86b610cadff351e9d8" => :high_sierra
    sha256 "6b7f53d6bb1b7e39f15959f5c8904ef9b481b4231f9b61adea6f0e868d231580" => :sierra
    sha256 "38e73129de528206a14d8fcb40b3589065c43e7296bba726c399b4f64a50e32e" => :el_capitan
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
