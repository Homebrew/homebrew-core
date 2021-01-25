require "language/node"

class WriteGood < Formula
  desc "Naive linter for English prose"
  homepage "https://github.com/btford/write-good"
  url "https://registry.npmjs.org/write-good/-/write-good-1.0.4.tgz"
  sha256 "c9de39a23d60d99e22878b1e7a847b03888f848d04c4691f50e894aea9d54c5f"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "37567d2c4ae6274cb8c02ce524d52bb30e09fb88013d558e76b74c67a9196bfb" => :big_sur
    sha256 "785f60e72a7fb8b15d1d839515df63f46f04487ebd5594cfa22bf39226096942" => :arm64_big_sur
    sha256 "93462e20926597984079f3d4d31a2228bce4ccfa31b646174344e5fa134505bb" => :catalina
    sha256 "66b39cc376254efd0a62240deb6212416c002d75643188f76c51fc586940899b" => :mojave
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
