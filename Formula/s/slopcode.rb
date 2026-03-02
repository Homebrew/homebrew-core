class Slopcode < Formula
  desc "The open source AI coding agent."
  homepage "https://slopcode.dev"
  url "https://registry.npmjs.org/slopcode/-/slopcode-0.0.12.tgz"
  sha256 "30735d84d777247dd7855497a10c107ee8c669486ded489c1582c73993fdec39"
  license "MIT"

  livecheck do
    throttle 10
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slopcode --version")
  end
end
