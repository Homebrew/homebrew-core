class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.44.0.tgz"
  sha256 "b90f0f4ae9b89a42ad3bdf7d11c50d81be86624f9be92c40b43af52db9fa092b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6988cbbdba8c1e1755a6dd19f267a8c569d3a31220a19fce98af435ccec39358"
    sha256 cellar: :any,                 arm64_sequoia: "77e2fcdf4669b2019b0a0e8508d00b303091fe8a3f26ccce2e29ba59ba955805"
    sha256 cellar: :any,                 arm64_sonoma:  "77e2fcdf4669b2019b0a0e8508d00b303091fe8a3f26ccce2e29ba59ba955805"
    sha256 cellar: :any,                 sonoma:        "30600fbcf81327a922afe68fa86ce12afebdfe0f25bbae2d530a58b73330ff4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d219a1393b5596604e4f78c7c9737483ef46dcd582e4d4e70d6f1f12dd3f315c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6fea09a9087b05f41bbe16a8c5aa4f55ec276622da971a07aca43a64c3a6d3b"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    rm_r node_modules/"sandbox/dist/pty-server-linux-x86_64"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
