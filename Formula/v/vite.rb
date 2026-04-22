class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.0.9.tgz"
  sha256 "d58ff29348314775802ba7242edee14cda108c797882759f53420395bea054f4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8ce7c47a0ee408d439629dff3d5a6375f856abd909f71048035d4015befd7417"
    sha256 cellar: :any,                 arm64_sequoia: "8a761d25d6792cf74a6613baed49aaddbdf5ebf7c399eff3e5976a5a80fdd6a2"
    sha256 cellar: :any,                 arm64_sonoma:  "8a761d25d6792cf74a6613baed49aaddbdf5ebf7c399eff3e5976a5a80fdd6a2"
    sha256 cellar: :any,                 sonoma:        "20f3d1a1f73dd3d252825d0d901feb29afc47d83c441ecea1899c002e49e50fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbd3a3ab6c94953064924fa0ae4a6f71ce10634a45a074e5430ff6e16198a409"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cfc4cbfa80e767eb0794996031a0e105e3e3a814a8ab2b714d99ec2ce70f3d2"
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
