require "language/node"

class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://github.com/google/zx"
  url "https://registry.npmjs.org/zx/-/zx-7.1.1.tgz"
  sha256 "cf8a969c2f4ab392c3ac971299861447d39ff4f917fdadfb46ecd95f4ebc20ae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69dd8bd86e217078cfd685a21e6dfa272dcbaf1b9be76939cc0ead669a2642fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69dd8bd86e217078cfd685a21e6dfa272dcbaf1b9be76939cc0ead669a2642fb"
    sha256 cellar: :any_skip_relocation, monterey:       "4547feea81e6443d2406c50e894e31ed8b28e352fbd1bad7a86c7be4dc780be3"
    sha256 cellar: :any_skip_relocation, big_sur:        "4547feea81e6443d2406c50e894e31ed8b28e352fbd1bad7a86c7be4dc780be3"
    sha256 cellar: :any_skip_relocation, catalina:       "4547feea81e6443d2406c50e894e31ed8b28e352fbd1bad7a86c7be4dc780be3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69dd8bd86e217078cfd685a21e6dfa272dcbaf1b9be76939cc0ead669a2642fb"
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
