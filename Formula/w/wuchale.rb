class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.25.6.tgz"
  sha256 "5cc7d5b7bab5d49948f8486083a69ca77a568a5e25f17d6ddcd8c3d58e1fa87f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "51e4086c131d825bc1e0254b8bfe9eb208d6bc96c27b74937c0e1134e1b43a56"
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
