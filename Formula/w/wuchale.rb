class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.23.3.tgz"
  sha256 "81a0d8d9882053a5c5dd97a0e44a3e717e436716802c26e540786ddf49b2faef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d3d71be3af528097de09c4ea407f30b5ec207cb388f28c044ed76753929d1239"
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
