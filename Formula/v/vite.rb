class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.1.3.tgz"
  sha256 "1abe868089430b14089cd4bfa5f7f403d10ec8497225c87a51224669e1765f5c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6b40e01858422e9301822b5f0dfa0c6d7986a6021547671c2b1b79a08d07ccdc"
    sha256 cellar: :any,                 arm64_sequoia: "ae2146bd603273ec968f0b5d0e4d3da295cebb461f79f996bd393b9612dbe281"
    sha256 cellar: :any,                 arm64_sonoma:  "ae2146bd603273ec968f0b5d0e4d3da295cebb461f79f996bd393b9612dbe281"
    sha256 cellar: :any,                 sonoma:        "32baa8d54640d250dd3c367b69504c4812556e034de4a948377e0acb5ae82496"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e386c1d563714fcc98ef1f829a8ac8f373f4d6c7ba80b63a319172931784bd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6af634118e9fc5557200e9e17bb7f54224f925dbb1ce841e69183a63b4e63758"
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
