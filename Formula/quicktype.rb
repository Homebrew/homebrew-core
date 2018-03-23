require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-9.0.26.tgz"
  sha256 "4ad0430d2b24bc75c907572b925cb8ab50d1ff267cd42f568bc7e0d7c0b3b695"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e67d838d61035b4e68da65b8718ad251dc2c0d641e8e47f7b42ff31f0f0fd55" => :high_sierra
    sha256 "0d24f95c02eb2db460bd35da45b5bb82b99b002415da4cf1a9c2528d8b8f18e1" => :sierra
    sha256 "58f29c30718f6823886b86254c1681ccb721770dff00aa448eec5786eaf0fb21" => :el_capitan
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
