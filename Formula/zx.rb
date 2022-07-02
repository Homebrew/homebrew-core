require "language/node"

class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://github.com/google/zx"
  url "https://registry.npmjs.org/zx/-/zx-7.0.6.tgz"
  sha256 "b79dcd1bc7b0c4bd0d132bac8b517223cd9efcee60f1cda7ce8fb78cc6172adc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b209b05d63c98f32b9d4dbaa243a5f52fd5b49a0ff6f9abc71a11b0d0bd4c030"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b209b05d63c98f32b9d4dbaa243a5f52fd5b49a0ff6f9abc71a11b0d0bd4c030"
    sha256 cellar: :any_skip_relocation, monterey:       "d5d81dda3b5b6a6ec4367ea276997875668fee0ab43e33e00d6758c7fc04ade8"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5d81dda3b5b6a6ec4367ea276997875668fee0ab43e33e00d6758c7fc04ade8"
    sha256 cellar: :any_skip_relocation, catalina:       "d5d81dda3b5b6a6ec4367ea276997875668fee0ab43e33e00d6758c7fc04ade8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b209b05d63c98f32b9d4dbaa243a5f52fd5b49a0ff6f9abc71a11b0d0bd4c030"
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
