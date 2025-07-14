class Sherif < Formula
  desc "Opinionated, zero-config linter for JavaScript monorepos"
  homepage "https://github.com/QuiiBz/sherif"
  url "https://registry.npmjs.org/sherif/-/sherif-1.6.1.tgz"
  sha256 "416172fbd1ec78120e8f90a8fb195a87030c2326a8ec3fd28d0af72aa51ecf68"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db665b67ba428ecbe45b2e073b31f8f0eecff7fb3ff2ba228605dd5eda5b7929"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db665b67ba428ecbe45b2e073b31f8f0eecff7fb3ff2ba228605dd5eda5b7929"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db665b67ba428ecbe45b2e073b31f8f0eecff7fb3ff2ba228605dd5eda5b7929"
    sha256 cellar: :any_skip_relocation, sonoma:        "92f725488d497b0431f3aa5421e48de0d76aed8aae3b177d728896c1fc5f82b6"
    sha256 cellar: :any_skip_relocation, ventura:       "92f725488d497b0431f3aa5421e48de0d76aed8aae3b177d728896c1fc5f82b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08781cd6ad44145185ecd7bf832faa60c21a8ff026069bbce5dee118e868e1ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "673f31fb70dddbd872763ca0bb3890b1cfdf4817ea6ced0183a8bb8011079fe9"
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
