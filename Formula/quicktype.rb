require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-9.0.26.tgz"
  sha256 "4ad0430d2b24bc75c907572b925cb8ab50d1ff267cd42f568bc7e0d7c0b3b695"

  bottle do
    cellar :any_skip_relocation
    sha256 "16994615b6807fb5e992869ff514e26a3bbacc41ba7c9c1f0494f925c5599bb4" => :high_sierra
    sha256 "8b9c39c1efb32410744fad0dbaa77bfad6e7a21d243dffd6b3e86f3ff573d6ec" => :sierra
    sha256 "80e207e5ac58180fe1fe852f92e7df354536a224ee3ccb56bc4aa8f4d802e000" => :el_capitan
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
