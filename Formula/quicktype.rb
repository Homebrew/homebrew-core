require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-22.0.0.tgz"
  sha256 "556244cf4beb7ba6cceb6dba52cb2d22ea3bcd72b893d9ee2524c8a20f1cba63"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bdc2e0af005b1c610d4ed3a4a292bc631fdc3361eb7fed85ab2766a5d625881a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdc2e0af005b1c610d4ed3a4a292bc631fdc3361eb7fed85ab2766a5d625881a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdc2e0af005b1c610d4ed3a4a292bc631fdc3361eb7fed85ab2766a5d625881a"
    sha256 cellar: :any_skip_relocation, ventura:        "2059e924db7a07c91c7b2b531a8c7679265da67709c41802be1508e5c3f5cc47"
    sha256 cellar: :any_skip_relocation, monterey:       "2059e924db7a07c91c7b2b531a8c7679265da67709c41802be1508e5c3f5cc47"
    sha256 cellar: :any_skip_relocation, big_sur:        "2059e924db7a07c91c7b2b531a8c7679265da67709c41802be1508e5c3f5cc47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdc2e0af005b1c610d4ed3a4a292bc631fdc3361eb7fed85ab2766a5d625881a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"sample.json").write <<~EOS
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    EOS
    output = shell_output("#{bin}/quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end
