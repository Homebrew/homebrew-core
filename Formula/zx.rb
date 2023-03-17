require "language/node"

class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://github.com/google/zx"
  url "https://registry.npmjs.org/zx/-/zx-7.2.1.tgz"
  sha256 "e5ddb8e7a3784899d8b00e5bc21471ad9be983d3fc893f75009ba69397ec5f9f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0de8218525deccbd26fc9192d3604e951d35640581d9effee644483e675b9e39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0de8218525deccbd26fc9192d3604e951d35640581d9effee644483e675b9e39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0de8218525deccbd26fc9192d3604e951d35640581d9effee644483e675b9e39"
    sha256 cellar: :any_skip_relocation, ventura:        "ed77e9a45af674f0cb590fb205a18991fad14c3f0103fb47e7392045ec3e5793"
    sha256 cellar: :any_skip_relocation, monterey:       "ed77e9a45af674f0cb590fb205a18991fad14c3f0103fb47e7392045ec3e5793"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed77e9a45af674f0cb590fb205a18991fad14c3f0103fb47e7392045ec3e5793"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0de8218525deccbd26fc9192d3604e951d35640581d9effee644483e675b9e39"
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
