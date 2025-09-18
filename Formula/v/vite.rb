class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-7.1.6.tgz"
  sha256 "c2d88f23d7e43dae59dffa451b3b3620e3c6a4cede3566cdf5eaea5bc8a1c3d2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a4084db56aa53b062cf2595bc7131f300d34a3872c8495c186ca620d03442623"
    sha256 cellar: :any,                 arm64_sequoia: "108ee1c482f68bbeb1cc07773f8ea660b961521c9f31f34499c7fec95272cdec"
    sha256 cellar: :any,                 arm64_sonoma:  "108ee1c482f68bbeb1cc07773f8ea660b961521c9f31f34499c7fec95272cdec"
    sha256 cellar: :any,                 sonoma:        "901dbca62d27ca36e8f02b6c274df69168560e9b243a622ba85ae23c6777ef71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9be484f5b01a041f73012f559f0015203cc442c9fb8ee3e25ef1551fa71451db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "065ec1d4d8647fce5b435a39266c23da641d4893f3acfec2a881096610ca6949"
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
