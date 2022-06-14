require "language/node"

class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://github.com/google/zx"
  url "https://registry.npmjs.org/zx/-/zx-7.0.0.tgz"
  sha256 "d2b902838cf3f5d0544fb8cb16b1a74d86fd1f637c40bc661f220411ca4890fc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "611b406a0f40c29297753643686113ffe7995b551431a9ee61ea709215dbf9a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "611b406a0f40c29297753643686113ffe7995b551431a9ee61ea709215dbf9a6"
    sha256 cellar: :any_skip_relocation, monterey:       "8b19b70cc024c62017f82faa65ba417393f328607d1b8488028b34aa16c5d42d"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b19b70cc024c62017f82faa65ba417393f328607d1b8488028b34aa16c5d42d"
    sha256 cellar: :any_skip_relocation, catalina:       "8b19b70cc024c62017f82faa65ba417393f328607d1b8488028b34aa16c5d42d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "611b406a0f40c29297753643686113ffe7995b551431a9ee61ea709215dbf9a6"
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
