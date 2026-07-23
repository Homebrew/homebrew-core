class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.1.5.tgz"
  sha256 "3ed0879c0db6411762d0ce96437954d85a9d17494dc4dc5871f1c239d7f13260"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e320526bd92f3f7e3678a930ac65ef70bbbcf38e5e47f28d25463b3837cf0fe9"
    sha256 cellar: :any,                 arm64_sequoia: "e320526bd92f3f7e3678a930ac65ef70bbbcf38e5e47f28d25463b3837cf0fe9"
    sha256 cellar: :any,                 arm64_sonoma:  "e320526bd92f3f7e3678a930ac65ef70bbbcf38e5e47f28d25463b3837cf0fe9"
    sha256 cellar: :any,                 sonoma:        "0c3d68305ffb7182d43636c122b261223c482864fec1818a45e92622883b699d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7ea0be9c40aa82e87684d4240e79c47d2a82e56cd0e82aa2edd384a0376f26b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ac21e1c426e8b9deb479237416312af7f70f01e83e1e2673a36b21a5dc3efda"
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
