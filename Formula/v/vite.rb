require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.1.3.tgz"
  sha256 "c4699c559ce3a0464853972fc34d091912454bf6318091806e30cfd37ca4e8d1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f5585fdc6af3ce464e8dc7e0e0de9a9cb82537398c2790072b70babd7ba532b2"
    sha256 cellar: :any,                 arm64_ventura:  "f5585fdc6af3ce464e8dc7e0e0de9a9cb82537398c2790072b70babd7ba532b2"
    sha256 cellar: :any,                 arm64_monterey: "f5585fdc6af3ce464e8dc7e0e0de9a9cb82537398c2790072b70babd7ba532b2"
    sha256 cellar: :any,                 sonoma:         "27e0c82df8d32146b61dd8e0b3e724333ec030e0d5adf8e63a9290fb86c11d0a"
    sha256 cellar: :any,                 ventura:        "27e0c82df8d32146b61dd8e0b3e724333ec030e0d5adf8e63a9290fb86c11d0a"
    sha256 cellar: :any,                 monterey:       "27e0c82df8d32146b61dd8e0b3e724333ec030e0d5adf8e63a9290fb86c11d0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c4e5aec0220f90705d4ebd350ec30e8b09169154db6c79286e1f58755f6458b"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/vite/node_modules"
    (node_modules/"@rollup/rollup-linux-x64-musl/rollup.linux-x64-musl.node").unlink if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end
