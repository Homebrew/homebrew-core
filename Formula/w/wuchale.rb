class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.19.4.tgz"
  sha256 "ac5f9e23ee2a76b3831f4e406e4ce1fa9c101ce11c11fc04514ef1a11444301f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "13939bd544eeb02c49dab03743bf079e5f3de7a15733129e04cf795bfebd07e8"
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
