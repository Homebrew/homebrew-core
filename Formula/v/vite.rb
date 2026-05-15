class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.0.12.tgz"
  sha256 "db89d9982c63fc0c6436f7c640b30abc211cd70af5201c2218e1396696ffdd74"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ebf07006714d76bcaa10194f7b021b937c0b40fb18c375e7c379366981376837"
    sha256 cellar: :any,                 arm64_sequoia: "d88e34912ecb9c961639754b8ef50ac66697162ba804793401f3e4e2dada61e4"
    sha256 cellar: :any,                 arm64_sonoma:  "d88e34912ecb9c961639754b8ef50ac66697162ba804793401f3e4e2dada61e4"
    sha256 cellar: :any,                 sonoma:        "a37e9f9ec2739a2e37ddaa44127b3bcf8a972b5e4a04d9b86fa6a207b2510188"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4461f39f75c8972dc339c8bf6f363fbd76993236f4034652ca09a1294a3f0ac1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c89d62641cdc29e3b1035df7bcad94e3c52d8ef92de39b80318c869140bcd9a"
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
