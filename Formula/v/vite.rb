class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-6.2.6.tgz"
  sha256 "33dc2a07ac78e84c3a4be04c58f38a16c3d196cfe7630daa94577bdb7ee49147"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9f7671199d14cb9295cf64c765d2b6fc3cfc7db8275d22d32147f7286e9877a0"
    sha256 cellar: :any,                 arm64_sonoma:  "9f7671199d14cb9295cf64c765d2b6fc3cfc7db8275d22d32147f7286e9877a0"
    sha256 cellar: :any,                 arm64_ventura: "9f7671199d14cb9295cf64c765d2b6fc3cfc7db8275d22d32147f7286e9877a0"
    sha256 cellar: :any,                 sonoma:        "451c09771ffb6e863c26e17a1ef503448072e847259d4cc38d7bdd766c42b7eb"
    sha256 cellar: :any,                 ventura:       "451c09771ffb6e863c26e17a1ef503448072e847259d4cc38d7bdd766c42b7eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f0e50d79c4c61079f562093e734ad3a4bb55b5b5180627166fa4cde0c6d7349"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f3764a20e505d86b2793b77317453fd8ef7a74ff6646b5e444ac9be1784baea"
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
