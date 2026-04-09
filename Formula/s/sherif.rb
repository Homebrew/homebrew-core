class Sherif < Formula
  desc "Opinionated, zero-config linter for JavaScript monorepos"
  homepage "https://github.com/QuiiBz/sherif"
  url "https://registry.npmjs.org/sherif/-/sherif-1.11.1.tgz"
  sha256 "7e8d671ab645e426fd57ed759b74af27238d93954c0a34ff7c645b39ed76af22"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe5b5fc9e5c3fcf97c87dd48df2b24ff667ca8a5ae733bb4ba477e4509c7d085"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe5b5fc9e5c3fcf97c87dd48df2b24ff667ca8a5ae733bb4ba477e4509c7d085"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe5b5fc9e5c3fcf97c87dd48df2b24ff667ca8a5ae733bb4ba477e4509c7d085"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bfb8c4be21f2607f0e6c48014bf08dbd94a799b8fd4d2676faa2621ff7d8085"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c91dc05db3f972d6442b8b9737d0e004e4408233ab3f27135fb46ca7bd78bca4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8462088add169c0f5395acd404a7a56bdc12393938c7a479d47ce635ef60a914"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
