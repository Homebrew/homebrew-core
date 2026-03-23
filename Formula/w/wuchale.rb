class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.22.2.tgz"
  sha256 "bc3b498b5d96d0d0f7241c1cb36a0d8f401fb7e8e2ed22eeb387050f5b5de102"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fcfd424c948134e0124a4f328ebe26bd173592ceb25ffda694e6ca6b9b16ccc9"
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

    output = shell_output("#{bin}/wuchale --config #{testpath}/wuchale.config.mjs status 2>&1", 1)
    assert_match "at least one adapter is needed.", output
  end
end
