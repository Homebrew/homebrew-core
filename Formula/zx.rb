require "language/node"

class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://github.com/google/zx"
  url "https://registry.npmjs.org/zx/-/zx-7.0.2.tgz"
  sha256 "d7d64f7c41713f12570950c91534b895749dbbe677c6d2bb3f04d0effd432686"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57c59b236331563608aceef2458eda18a8b0f0790cac5f366ea03ee7f308ba3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57c59b236331563608aceef2458eda18a8b0f0790cac5f366ea03ee7f308ba3b"
    sha256 cellar: :any_skip_relocation, monterey:       "b788e63e4d38d924363c0334e43eb6cae569e7512a4effafa227931571273621"
    sha256 cellar: :any_skip_relocation, big_sur:        "b788e63e4d38d924363c0334e43eb6cae569e7512a4effafa227931571273621"
    sha256 cellar: :any_skip_relocation, catalina:       "b788e63e4d38d924363c0334e43eb6cae569e7512a4effafa227931571273621"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57c59b236331563608aceef2458eda18a8b0f0790cac5f366ea03ee7f308ba3b"
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
