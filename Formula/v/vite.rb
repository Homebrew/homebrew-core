class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-7.3.1.tgz"
  sha256 "db84c382a086feb54ccb68b285aa71eff333156cd184299f754003b13682fb85"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e43fb5537f0135fc9428b8bb44475da40ebc208cf6755cc45afb6aff94a51a41"
    sha256 cellar: :any,                 arm64_sequoia: "bbf7d68926482d6978cad3cafc734aadea2e8b1f8d980f4c6224af47c1c4c7e9"
    sha256 cellar: :any,                 arm64_sonoma:  "bbf7d68926482d6978cad3cafc734aadea2e8b1f8d980f4c6224af47c1c4c7e9"
    sha256 cellar: :any,                 sonoma:        "28150dda3e9814e02c0ac18572fafabdb0ba139ab91f7d8f9e9b948779e67786"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45a663eb6e1f53b5fe331cd0affc216be184fdad969fd6a6152096e5f2e646bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bde990a64b80ebb7234ff436c16cdfc2bf67a45d09d2d83259b8d5c9bb18e48"
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
