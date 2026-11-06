class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.3.6.tgz"
  sha256 "37d3d625af80de80e6fb51b97bebd79c15a767aace9818675cd475f480a840ee"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "e5908e5a467c759fc0552301f332bc348dc396583ade46fd1e937c98785d5a3e"
    sha256 cellar: :any,                 arm64_tahoe:       "e5908e5a467c759fc0552301f332bc348dc396583ade46fd1e937c98785d5a3e"
    sha256 cellar: :any,                 arm64_sequoia:     "e5908e5a467c759fc0552301f332bc348dc396583ade46fd1e937c98785d5a3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "42ed586f261d81bab4ebf483e2c3749e09a2d1deb26c44d3fbd779a04f942017"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0b3a6b87102f548c53a0a360ec5d6b90414cd387ca8ee6356c33bf36f6e4bafe"
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
