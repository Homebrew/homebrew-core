require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-15.0.260.tgz"
  sha256 "57ffeb7f12f3c3476bd7e0213716006b49a8159c20e63fd60cb07eefa4289b6f"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2fa5aaec1d5d1cb1809dd3ad614dda13af59447772cfa4526945e4fbedcd780e"
    sha256 cellar: :any_skip_relocation, big_sur:       "b2a13d97e30ebcbff8e32903e82ad8857ed108ad84e695cb92df7e870c7948bd"
    sha256 cellar: :any_skip_relocation, catalina:      "313dd23d76101d388259319a688d84a0cb5d44a16e7d34b4a0b7611048d995a4"
    sha256 cellar: :any_skip_relocation, mojave:        "81f40f8f11e16c51c4e30881094256be0b9f91228e2ebf131d261c5ee6a8339c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59a2b6555eebd5c338dee762e7685577bd1ea0e5db27686c139a9bdb393e9548"
    sha256 cellar: :any_skip_relocation, all:           "2570eed33dcd2c39f8ef430e0a5ac3df428d5d74b9755b7064140ced95cc80c5"
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
