class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.21.2.tgz"
  sha256 "a46351b52bb179af617b39b3db14b4b66b497409011ad4f4037616a39215a51f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fc7e22ae2f0485822d4cf16dbb22df68a905c22162f518e92cc59a588101542f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"wuchale.config.mjs").write <<~EOS
      export default {
        locales: ["en"]
      };
    EOS

    output = shell_output("#{bin}/wuchale --config #{testpath}/wuchale.config.mjs status")
    assert_match "Locales: \e[36men (English)\e[0m", output
  end
end
