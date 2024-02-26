require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.1.4.tgz"
  sha256 "5b610a263e8e8b6b939595763c0016976e7f7991dd0ee1fb081b5adca5ab7e4d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e822dce85cdb8b335bd475f65cd20e705d1abfb23d7a81a3f1fb898a5e2527f9"
    sha256 cellar: :any,                 arm64_ventura:  "e822dce85cdb8b335bd475f65cd20e705d1abfb23d7a81a3f1fb898a5e2527f9"
    sha256 cellar: :any,                 arm64_monterey: "e822dce85cdb8b335bd475f65cd20e705d1abfb23d7a81a3f1fb898a5e2527f9"
    sha256 cellar: :any,                 sonoma:         "8be541495bdd8fba491e4f8c737fb2e23b894e8084c2ba8505f3ff33055b4084"
    sha256 cellar: :any,                 ventura:        "8be541495bdd8fba491e4f8c737fb2e23b894e8084c2ba8505f3ff33055b4084"
    sha256 cellar: :any,                 monterey:       "8be541495bdd8fba491e4f8c737fb2e23b894e8084c2ba8505f3ff33055b4084"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10ee074ee7d38e7e8e67870ffd0e6a78f2442cd698ef3bc549d55d81cefaf59a"
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
