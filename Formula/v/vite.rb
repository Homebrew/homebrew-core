require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.0.10.tgz"
  sha256 "75ef2186189dd6caa7e509e27f380af516c6c0e8e9552c75678f013bf4812a99"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "56f6a823b6106e2ab3e5650023ee06052672aa10588093753a8955874fc4fdcf"
    sha256 cellar: :any,                 arm64_ventura:  "56f6a823b6106e2ab3e5650023ee06052672aa10588093753a8955874fc4fdcf"
    sha256 cellar: :any,                 arm64_monterey: "56f6a823b6106e2ab3e5650023ee06052672aa10588093753a8955874fc4fdcf"
    sha256 cellar: :any,                 sonoma:         "11391956f35f6235876285a0c5778226eac4fa87b184fe7a2f1b547fa611a33e"
    sha256 cellar: :any,                 ventura:        "11391956f35f6235876285a0c5778226eac4fa87b184fe7a2f1b547fa611a33e"
    sha256 cellar: :any,                 monterey:       "11391956f35f6235876285a0c5778226eac4fa87b184fe7a2f1b547fa611a33e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a5391f8f5302c9b553dd54903b9ce11c84e25d0f531f91e0f879a6a20279a40"
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
