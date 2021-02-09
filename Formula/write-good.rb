require "language/node"

class WriteGood < Formula
  desc "Naive linter for English prose"
  homepage "https://github.com/btford/write-good"
  url "https://registry.npmjs.org/write-good/-/write-good-1.0.6.tgz"
  sha256 "cc63cf27c95db982aabcc9cd2fa59e55382589f6e75ee17f26ebea941f715351"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dcb36d15082245bd32277d964bd77d11f3610a9e0cf48401bf20ca7cff2291bc"
    sha256 cellar: :any_skip_relocation, big_sur:       "17ed562f70bddc92d7f52a4c1e8cf62bbc1aef49d51e78076dd357044737545b"
    sha256 cellar: :any_skip_relocation, catalina:      "af36a1a3ec8609ee811afd157bacc62503c0f96b7b91571a2d4b114277fca274"
    sha256 cellar: :any_skip_relocation, mojave:        "5f60c1de800c479bfa7d1f4995e9fb7bb0e58e718314888329a7bfbc00ed9aa5"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.txt").write "So the cat was stolen."
    assert_match "passive voice", shell_output("#{bin}/write-good test.txt", 2)
  end
end
