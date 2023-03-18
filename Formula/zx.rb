require "language/node"

class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://github.com/google/zx"
  url "https://registry.npmjs.org/zx/-/zx-7.2.1.tgz"
  sha256 "e5ddb8e7a3784899d8b00e5bc21471ad9be983d3fc893f75009ba69397ec5f9f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34fe852ca4bf633896936bdbd1ffbbc92643a8c90d661a785f1b0628e7ad3231"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34fe852ca4bf633896936bdbd1ffbbc92643a8c90d661a785f1b0628e7ad3231"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34fe852ca4bf633896936bdbd1ffbbc92643a8c90d661a785f1b0628e7ad3231"
    sha256 cellar: :any_skip_relocation, ventura:        "07e910c25261742ae2fa2f7b8e762ed6c31dcec1e23e50ff16881802bf4e0ef7"
    sha256 cellar: :any_skip_relocation, monterey:       "07e910c25261742ae2fa2f7b8e762ed6c31dcec1e23e50ff16881802bf4e0ef7"
    sha256 cellar: :any_skip_relocation, big_sur:        "07e910c25261742ae2fa2f7b8e762ed6c31dcec1e23e50ff16881802bf4e0ef7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34fe852ca4bf633896936bdbd1ffbbc92643a8c90d661a785f1b0628e7ad3231"
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
