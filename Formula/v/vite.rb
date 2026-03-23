class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.0.2.tgz"
  sha256 "652897103a0913d0f53b6e449472b0f614a88141c3209df82bb8751d57aacb09"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "659c70d0b9ab614c9706ea6b40a5c96b657ac47bd1b79c09714e90b3afa2d8a5"
    sha256 cellar: :any,                 arm64_sequoia: "4fc62632515cd1df2445230edf8ae29ce98bf88830e25506e07b8090dd36dfe2"
    sha256 cellar: :any,                 arm64_sonoma:  "4fc62632515cd1df2445230edf8ae29ce98bf88830e25506e07b8090dd36dfe2"
    sha256 cellar: :any,                 sonoma:        "4f8717dfd5b51554fe8649d061a8e6f5fc2d3078a371c82414688723351064fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13e509472869e9be578e80c7bdcf53db107885e689a9399d5d75185125e1029c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d8defd78e8978b4c22c53370ff8598a918fc91be5c056de44500ea5c1dcdb5e"
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
