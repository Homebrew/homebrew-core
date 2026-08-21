class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.2.2.tgz"
  sha256 "99df542e1d7267c0da524bdb216ebc32a4dfefc17f8fe830067b62a1042fbeb7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b8a8c02330cb0bf3b8e4c61f1860b4422526a481ed2f56705e6e91d5db2cca1a"
    sha256 cellar: :any,                 arm64_sequoia: "b8a8c02330cb0bf3b8e4c61f1860b4422526a481ed2f56705e6e91d5db2cca1a"
    sha256 cellar: :any,                 arm64_sonoma:  "b8a8c02330cb0bf3b8e4c61f1860b4422526a481ed2f56705e6e91d5db2cca1a"
    sha256 cellar: :any,                 sonoma:        "1c1a5ef3fab82d27182547a492de1e99c72f66f7b256ffe855ef3edaa980f560"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "459e31595a526be0752661dd71ece9955160f607f5486ef9fc583ca74a76ec27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a2fccfa00ccfa20a4f8f59bab644e724e697f8ddb6deaa8a61003ed686a0fb8"
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
