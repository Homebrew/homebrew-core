class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-7.1.7.tgz"
  sha256 "777568ebd6b8f54bbd07c9fd8b98bdf33f58e3dc5a1b647c0a59ed8c6760582f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ab9a1249a8fb9cc6413643c451281c456f572ae0f64aed19d9c99f8d581e45f8"
    sha256 cellar: :any,                 arm64_sequoia: "9a2f7897d14053a41b9e966c79ae3834879d3212e13401091c03f57808ab4315"
    sha256 cellar: :any,                 arm64_sonoma:  "9a2f7897d14053a41b9e966c79ae3834879d3212e13401091c03f57808ab4315"
    sha256 cellar: :any,                 sonoma:        "25b9b4ce119c1a5882e5ba05182f7cbd07700a6abeaf21f08d7d213b36d267f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a67c5753d5b6ed311ddd37d205b956b59439000765d50501fa16358ee69a9202"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1a21c322b0347570a5ccb9fd8aba71df3d7bf8f34ebd57b64d2b1d5205079e1"
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
