class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://google.github.io/zx/"
  url "https://registry.npmjs.org/zx/-/zx-8.8.1.tgz"
  sha256 "50025fb3748232b1facea458c4b07a671e0b9893880c7b573e33dbc7ccf8b102"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bdd6fb9a017f89677cfeb86efb81afdd1d81d60b5e48e7acf197ca89ff5db3ad"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.mjs").write <<~JAVASCRIPT
      #!/usr/bin/env zx

      let name = YAML.parse('foo: bar').foo
      console.log(`name is ${name}`)
      await $`touch ${name}`
    JAVASCRIPT

    output = shell_output("#{bin}/zx #{testpath}/test.mjs")
    assert_match "name is bar", output
    assert_path_exists testpath/"bar"

    assert_match version.to_s, shell_output("#{bin}/zx --version")
  end
end
