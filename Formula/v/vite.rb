class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-7.0.4.tgz"
  sha256 "d6266ad560a43712fca72e24e152cd45e9b155b5705db9ca5db6000015250c39"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cb1742fcf652a110e5cc6dc9f31edbe59595ffd41965c00c8938af58f1bd143c"
    sha256 cellar: :any,                 arm64_sonoma:  "cb1742fcf652a110e5cc6dc9f31edbe59595ffd41965c00c8938af58f1bd143c"
    sha256 cellar: :any,                 arm64_ventura: "cb1742fcf652a110e5cc6dc9f31edbe59595ffd41965c00c8938af58f1bd143c"
    sha256 cellar: :any,                 sonoma:        "31caaaad253d6abcbac70ff8404fc007c8e0675a69859f447f82acde73374543"
    sha256 cellar: :any,                 ventura:       "31caaaad253d6abcbac70ff8404fc007c8e0675a69859f447f82acde73374543"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62cb4ff01ef9805c6b162103cd6c2a1dcf2c1406993a5c7e39598d5bc7cc4ea6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70485bb1cea3594bbf96e1589f87a704ca4b5de093dabc44352aa62806a0eefe"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end
