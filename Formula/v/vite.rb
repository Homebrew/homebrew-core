require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.0.9.tgz"
  sha256 "914a1c35b622302f7ee6e88f8336d9d62f64986ea614907d3e593ecffb7059d5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a41f68020f1f3b683a22209cf1b49bc91b646d00f0445f32fb387534cf53e8f0"
    sha256 cellar: :any,                 arm64_ventura:  "a41f68020f1f3b683a22209cf1b49bc91b646d00f0445f32fb387534cf53e8f0"
    sha256 cellar: :any,                 arm64_monterey: "a41f68020f1f3b683a22209cf1b49bc91b646d00f0445f32fb387534cf53e8f0"
    sha256 cellar: :any,                 sonoma:         "d5ca12d64868619d90c9ef354502f287c0fa5b80e1cee6849e28e615b674da69"
    sha256 cellar: :any,                 ventura:        "d5ca12d64868619d90c9ef354502f287c0fa5b80e1cee6849e28e615b674da69"
    sha256 cellar: :any,                 monterey:       "d5ca12d64868619d90c9ef354502f287c0fa5b80e1cee6849e28e615b674da69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9130e0753788c487abaf3cc869f22d2d4e9de6bf21785bbb784924149203c4e"
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
