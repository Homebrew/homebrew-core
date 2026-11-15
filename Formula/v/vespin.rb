class Vespin < Formula
  desc "Unified workspace for teams and agents, from the terminal"
  homepage "https://vespin.dev"
  url "https://registry.npmjs.org/vespin/-/vespin-0.3.0.tgz"
  sha256 "62160b5f727de5af9421b8412be11344ecee03e6f81c5a0abc107c5a4d8cc7b6"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vespin --version")
    assert_match "USAGE", shell_output("#{bin}/vespin --help")
  end
end
