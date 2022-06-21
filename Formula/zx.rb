require "language/node"

class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://github.com/google/zx"
  url "https://registry.npmjs.org/zx/-/zx-7.0.1.tgz"
  sha256 "e3e658c143bd03a9ed65a1271c65ef0fcb0471bb9f5c3acd259b3dbbb59c5539"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b5ce50d1e3fc137fd552c5355601a1fddd508bab0e2c72b227999793869c864"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b5ce50d1e3fc137fd552c5355601a1fddd508bab0e2c72b227999793869c864"
    sha256 cellar: :any_skip_relocation, monterey:       "30e76f3fc400193aa95ceb3f79199a450bfbd3c60a8a811fd292aae47785b729"
    sha256 cellar: :any_skip_relocation, big_sur:        "30e76f3fc400193aa95ceb3f79199a450bfbd3c60a8a811fd292aae47785b729"
    sha256 cellar: :any_skip_relocation, catalina:       "30e76f3fc400193aa95ceb3f79199a450bfbd3c60a8a811fd292aae47785b729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b5ce50d1e3fc137fd552c5355601a1fddd508bab0e2c72b227999793869c864"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.mjs").write <<~EOS
      #!/usr/bin/env zx

      let name = YAML.parse('foo: bar').foo
      console.log(`name is ${name}`)
      await $`touch ${name}`
    EOS

    output = shell_output("#{bin}/zx #{testpath}/test.mjs")
    assert_match "name is bar", output
    assert_predicate testpath/"bar", :exist?

    assert_match version.to_s, shell_output("#{bin}/zx --version")
  end
end
