require "language/node"

class WriteGood < Formula
  desc "Naive linter for English prose"
  homepage "https://github.com/btford/write-good"
  url "https://registry.npmjs.org/write-good/-/write-good-1.0.5.tgz"
  sha256 "efffbfb63057ad214ff07957a5423b7e9fb75f4cae45ebf013554defe0bdb3e5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "785f60e72a7fb8b15d1d839515df63f46f04487ebd5594cfa22bf39226096942"
    sha256 cellar: :any_skip_relocation, big_sur:       "37567d2c4ae6274cb8c02ce524d52bb30e09fb88013d558e76b74c67a9196bfb"
    sha256 cellar: :any_skip_relocation, catalina:      "93462e20926597984079f3d4d31a2228bce4ccfa31b646174344e5fa134505bb"
    sha256 cellar: :any_skip_relocation, mojave:        "66b39cc376254efd0a62240deb6212416c002d75643188f76c51fc586940899b"
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
