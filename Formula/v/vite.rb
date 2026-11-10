class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.3.7.tgz"
  sha256 "88296b635f664eb07c07d593a3c4ea06ef295b05205c03adb43d2e381246c319"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "0f40e743cb2059d3623e0dfd150ea26c1b8ad802b98640051889febcd9e9a643"
    sha256 cellar: :any,                 arm64_tahoe:       "0f40e743cb2059d3623e0dfd150ea26c1b8ad802b98640051889febcd9e9a643"
    sha256 cellar: :any,                 arm64_sequoia:     "0f40e743cb2059d3623e0dfd150ea26c1b8ad802b98640051889febcd9e9a643"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5aaf5b9377a03e2d8a6af9cdac227685f873ce0d622632d8cca24ee68a9f6f76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e65f992b0d1211eea21aeae5331e0fac5ff4566be1c6ac0bb21d51a329b312cd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/vite/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end
