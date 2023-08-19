require "language/node"

class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://github.com/google/zx"
  url "https://registry.npmjs.org/zx/-/zx-7.2.3.tgz"
  sha256 "2644e2e596dc2e60f0a37491a342301594f07e073495da14665fa244e9b01aac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "543e21439f8c31d8aab38fdff7e374aad1d8f36cc9ad16b474162294d78dca2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "543e21439f8c31d8aab38fdff7e374aad1d8f36cc9ad16b474162294d78dca2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "543e21439f8c31d8aab38fdff7e374aad1d8f36cc9ad16b474162294d78dca2b"
    sha256 cellar: :any_skip_relocation, ventura:        "655673ef365dc41ce93cc8d421f1a80fde74070e1a6d8dd11de54944df89abe0"
    sha256 cellar: :any_skip_relocation, monterey:       "655673ef365dc41ce93cc8d421f1a80fde74070e1a6d8dd11de54944df89abe0"
    sha256 cellar: :any_skip_relocation, big_sur:        "655673ef365dc41ce93cc8d421f1a80fde74070e1a6d8dd11de54944df89abe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "543e21439f8c31d8aab38fdff7e374aad1d8f36cc9ad16b474162294d78dca2b"
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
