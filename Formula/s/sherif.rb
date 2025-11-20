class Sherif < Formula
  desc "Opinionated, zero-config linter for JavaScript monorepos"
  homepage "https://github.com/QuiiBz/sherif"
  url "https://registry.npmjs.org/sherif/-/sherif-1.9.0.tgz"
  sha256 "c3f0229293efbdeb9118e373238a19a96879f441e5c75348925cb365b471cac5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04be639f56c6492ce49cc215fd8fd1896daa5fbd9a4d26549541f934e7e7ce0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04be639f56c6492ce49cc215fd8fd1896daa5fbd9a4d26549541f934e7e7ce0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04be639f56c6492ce49cc215fd8fd1896daa5fbd9a4d26549541f934e7e7ce0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5a0a4c778d9f96fc9afca83405ea942bee15aab5cbb9e25eece722af233b021"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f60a64c8a3081446c378d870d428d231f4105090c54ffa1d9df838d7c82e6358"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "545173b12e4e441867e4dc2658da0a9d270ba452b97b9d0ce762833a618c9611"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "test",
        "version": "1.0.0",
        "private": true,
        "packageManager": "npm",
        "workspaces": [ "." ]
      }
    JSON
    (testpath/"test.js").write <<~JS
      console.log('Hello, world!');
    JS
    assert_match "No issues found", shell_output("#{bin}/sherif --no-install .")
  end
end
