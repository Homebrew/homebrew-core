class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.0.1.tgz"
  sha256 "3a08b87cea9dd5232e2b18c1b36b41bcba8a285e9031d9d2437ca708a472f808"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "61794fedb203418e2161436b717cb15efa6af1ecd2deddb22a805569a4ea55e0"
    sha256 cellar: :any,                 arm64_sequoia: "b20a6273b0d31b6e29abe088818394ad76c8eb31a5ee8df1e3340e8375cdb6eb"
    sha256 cellar: :any,                 arm64_sonoma:  "b20a6273b0d31b6e29abe088818394ad76c8eb31a5ee8df1e3340e8375cdb6eb"
    sha256 cellar: :any,                 sonoma:        "ece5ed57322cc9c465b37ab595c6440e7e97b799908e6920459b3b9122e6e48a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8a683fb69ebe2480e353dcddcde6ae18f899c4a1b2c14f38cc297c9e0d8b69d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "769e92afd96e72a3a53a6e6d07830505acc5a388f058d018e3256de6ce2484b9"
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
