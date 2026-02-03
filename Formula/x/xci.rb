class Xci < Formula
  desc "Local GitHub Actions runner UX powered by act"
  homepage "https://github.com/moehaje/xci#readme"
  url "https://registry.npmjs.org/@artsnlabs/xci/-/xci-0.1.5.tgz"
  sha256 "6ece7f8874557ef116253494f61b72770d91e178d89f4b56296eeb8a9552042d"
  license "MIT"

  depends_on "act"
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xci --version")
    assert_match "run", shell_output("#{bin}/xci --help")
  end
end
