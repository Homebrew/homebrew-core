require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.75.tgz"
  sha256 "5c520a710c24dd4538e891ad6b38ad644e78744b196d4c150962eb0aabf0c7bb"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bab139097c829a003bf91b326708cc42cfb67710b084cf61c6c9d9826cb70420"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bab139097c829a003bf91b326708cc42cfb67710b084cf61c6c9d9826cb70420"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bab139097c829a003bf91b326708cc42cfb67710b084cf61c6c9d9826cb70420"
    sha256 cellar: :any_skip_relocation, ventura:        "f6545d2a41a932a3dedc3ed9af61ec5ae907a512751151b7ddcdb909048f0e81"
    sha256 cellar: :any_skip_relocation, monterey:       "f6545d2a41a932a3dedc3ed9af61ec5ae907a512751151b7ddcdb909048f0e81"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6545d2a41a932a3dedc3ed9af61ec5ae907a512751151b7ddcdb909048f0e81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bab139097c829a003bf91b326708cc42cfb67710b084cf61c6c9d9826cb70420"
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
