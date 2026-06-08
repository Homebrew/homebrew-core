class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.0.16.tgz"
  sha256 "3af821aa696cac7f3722ba8db24eff8da9d8739ce8279bc318e1549fa9ec5287"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4f4a142c503f232e5c3d913cebf6d3fdd3604f4f7921f1f7c386b950fbe2f3aa"
    sha256 cellar: :any,                 arm64_sequoia: "2d3651bfc4ffd0e70d93f54047d3cc3db31200797b53ef5adcd49be06447ec17"
    sha256 cellar: :any,                 arm64_sonoma:  "2d3651bfc4ffd0e70d93f54047d3cc3db31200797b53ef5adcd49be06447ec17"
    sha256 cellar: :any,                 sonoma:        "1be2c6ce48d4773fc1810bd8d7f8ed5379d209ac0f29dec5636d4ce750d4b9de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb481b6419fb852e9e8c89fc97ab3088c0b17e3615b626f120e7ca6f2073ab04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "802280beb804847a52ee402a998b01aebd69a2ed121e96107d6c916a308797a4"
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
