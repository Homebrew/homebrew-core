class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.3.4.tgz"
  sha256 "f8735b2c43d2e53678a994c11e914b76d9cd034b72aa7b9d59194a46b19b4de5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "2bffc05182f01b50aa61776ff5c2b2e3f9c91c8584c42dbf51d15a884e7654c4"
    sha256 cellar: :any,                 arm64_tahoe:       "2bffc05182f01b50aa61776ff5c2b2e3f9c91c8584c42dbf51d15a884e7654c4"
    sha256 cellar: :any,                 arm64_sequoia:     "2bffc05182f01b50aa61776ff5c2b2e3f9c91c8584c42dbf51d15a884e7654c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4db950971ce46f194a5e7d16af606e384bc4823a4ec2c5cc0a337f958420520c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b27aa801c8fe12542c475ce886d5e6924846973ad310a234c47a63221dd39343"
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
