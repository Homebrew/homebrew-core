require "language/node"

class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://github.com/google/zx"
  url "https://registry.npmjs.org/zx/-/zx-7.0.7.tgz"
  sha256 "40e2f920b116f6dbec11eb58ad2df5d429cbc4c3c9635f422d9256536ac618ac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bd2ac0b40878fab34959d270c2b4fd1852193717f5f145b76a5f4eefde2c4e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0bd2ac0b40878fab34959d270c2b4fd1852193717f5f145b76a5f4eefde2c4e3"
    sha256 cellar: :any_skip_relocation, monterey:       "a765a0fa1d56177c835579283ace2bff421f35806937d9edfeafa17fba4c53ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "a765a0fa1d56177c835579283ace2bff421f35806937d9edfeafa17fba4c53ec"
    sha256 cellar: :any_skip_relocation, catalina:       "a765a0fa1d56177c835579283ace2bff421f35806937d9edfeafa17fba4c53ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bd2ac0b40878fab34959d270c2b4fd1852193717f5f145b76a5f4eefde2c4e3"
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
