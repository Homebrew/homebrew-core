require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-15.0.50.tgz"
  sha256 "207888dcc8105fee832679d7e62c9be56fe1c41ce74d4add88fee39d2ac13cf9"

  bottle do
    cellar :any_skip_relocation
    sha256 "0fa54d5a641bf25d5410c5123210bba92a8653d007c89bc11a2cb48150e1aa21" => :high_sierra
    sha256 "49f0b37d2bfd4883da89bf528dd711a28697ee02eb0f19d979d82c59e5e7c4fd" => :sierra
    sha256 "edf5735bba841bafdfa2583e7911c6fce71094c9340399c2cda7524efdef7e11" => :el_capitan
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
