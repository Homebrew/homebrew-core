class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.25.0.tgz"
  sha256 "0efd83dae8a2fd907ae3e429b59ae80a120556ad17b00b805f134814b6e99d39"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9966b36886a482b178b9b1deba50a9f3f8f5a8cdd1ccb000a0ff249e3f3cb7bd"
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
