class Synchrony < Formula
  desc "Simple deobfuscator for mangled or obfuscated JavaScript files"
  homepage "https://deobfuscate.relative.im/"
  url "https://registry.npmjs.org/deobfuscator/-/deobfuscator-2.4.6.tgz"
  sha256 "c7fe43892389a34dec7d84328a68e381820cad9a03d5a93ed2e6e055645be7b6"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4e6ede52ee4b2c8e264de762f4eba484befa3a1204a4001f4e0f9e59959db6a5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    resource "test-file" do
      url "https://gist.githubusercontent.com/relative/79e392bced4b9bed8fd076f834e06dee/raw/obfuscated.js"
      sha256 "01058a548c9beb1df0586ddb30ca88256b15dba4bd5b95ddf90541dbaceef0b0"
    end

    testpath.install resource("test-file")
    system bin/"synchrony", "deobfuscate", "obfuscated.js"
    assert_match "console.log('test message');", (testpath/"obfuscated.cleaned.js").read

    assert_match version.to_s, shell_output("#{bin}/synchrony --version")
  end
end
