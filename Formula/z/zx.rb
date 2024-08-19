class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://github.com/google/zx"
  url "https://registry.npmjs.org/zx/-/zx-8.1.4.tgz"
  sha256 "dfdf71de383d5145c01063dd32fdfee95bbfd145b1470a4b69a995a33c752ca1"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b454c529e1dc9d1dc584f6eb948c8e3a9937735b674e059a501e024bb7a4cef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b454c529e1dc9d1dc584f6eb948c8e3a9937735b674e059a501e024bb7a4cef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b454c529e1dc9d1dc584f6eb948c8e3a9937735b674e059a501e024bb7a4cef"
    sha256 cellar: :any_skip_relocation, sonoma:         "581b54bc7ee2b94eedb6129b6e510d5ac8998e551ddc4898af8273870619fe3c"
    sha256 cellar: :any_skip_relocation, ventura:        "581b54bc7ee2b94eedb6129b6e510d5ac8998e551ddc4898af8273870619fe3c"
    sha256 cellar: :any_skip_relocation, monterey:       "581b54bc7ee2b94eedb6129b6e510d5ac8998e551ddc4898af8273870619fe3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9b3a8e018f04112082fd0c0440304648cdba4d3f64bfc2cc1a3f5c53fcea71f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
