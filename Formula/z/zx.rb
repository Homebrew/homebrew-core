require "language/node"

class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://github.com/google/zx"
  url "https://registry.npmjs.org/zx/-/zx-8.0.1.tgz"
  sha256 "0fc88a7b64f0343f5e69e164be6189bed3382aabc082f0ad7b9f02d0d7e04c8a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5990272a1c3bc7c9d089b293a3b6826bffd06aeae003bc3193bb7d3e7d958df6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5990272a1c3bc7c9d089b293a3b6826bffd06aeae003bc3193bb7d3e7d958df6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5990272a1c3bc7c9d089b293a3b6826bffd06aeae003bc3193bb7d3e7d958df6"
    sha256 cellar: :any_skip_relocation, sonoma:         "52c9915d029026f3655745365013bbc190971283fa908bddb169e963225f8df7"
    sha256 cellar: :any_skip_relocation, ventura:        "52c9915d029026f3655745365013bbc190971283fa908bddb169e963225f8df7"
    sha256 cellar: :any_skip_relocation, monterey:       "52c9915d029026f3655745365013bbc190971283fa908bddb169e963225f8df7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5990272a1c3bc7c9d089b293a3b6826bffd06aeae003bc3193bb7d3e7d958df6"
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
