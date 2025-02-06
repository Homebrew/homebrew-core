class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-6.1.0.tgz"
  sha256 "36b851cfb408c1c4c2d0080168791afd5390a88c1db74f2747b65b7572eb293e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9a445c57c7f1a68232e76c5a2a4640f769c2149742c814b6446595c93c4d8c1e"
    sha256 cellar: :any,                 arm64_sonoma:  "9a445c57c7f1a68232e76c5a2a4640f769c2149742c814b6446595c93c4d8c1e"
    sha256 cellar: :any,                 arm64_ventura: "9a445c57c7f1a68232e76c5a2a4640f769c2149742c814b6446595c93c4d8c1e"
    sha256 cellar: :any,                 sonoma:        "7d387f8f68e4b397dde820a5632e39369ce1130ef1c0c00ec086dbbfed8966fd"
    sha256 cellar: :any,                 ventura:       "7d387f8f68e4b397dde820a5632e39369ce1130ef1c0c00ec086dbbfed8966fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7201aca3de7579f155c498bac9c254ccc7663c6eb77c6e9a96be4f2f1a69c99"
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
