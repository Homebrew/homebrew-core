require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-15.0.50.tgz"
  sha256 "207888dcc8105fee832679d7e62c9be56fe1c41ce74d4add88fee39d2ac13cf9"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3273c991ad95952943a275d0a5ddfd510ef5555dd576b9360cc98616b60d142" => :high_sierra
    sha256 "08c8ca4c0057ae627a7b402c113bf3ef12ef8b4672370610bf93d6e004bcab51" => :sierra
    sha256 "d8cba05d03be618f05f0c33badc53d76e04d8e95e5f6856eb24c4872b122954b" => :el_capitan
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
