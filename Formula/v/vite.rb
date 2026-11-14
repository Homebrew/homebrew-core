class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.3.8.tgz"
  sha256 "96b14ea41f889b70b1ccf74dd5861e365816fce8632c5073ce8d70c90509738b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "5d7479f007a0e4a3796f05e689e0c00ffb603b871697f5ef9370a020ebd20991"
    sha256 cellar: :any,                 arm64_tahoe:       "5d7479f007a0e4a3796f05e689e0c00ffb603b871697f5ef9370a020ebd20991"
    sha256 cellar: :any,                 arm64_sequoia:     "5d7479f007a0e4a3796f05e689e0c00ffb603b871697f5ef9370a020ebd20991"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "01fcad6895abfd521645bf27ea4540358a211268e09d8cbebcd203227587b64e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2681f7a88616ca0a75c1d7fc8097cce69a7c69d1235f87b2cd6e56f616301246"
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
