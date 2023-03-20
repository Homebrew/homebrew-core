require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.10.tgz"
  sha256 "98a20e848e70b0f9e08fe7689c58c2d925270d0d837e9380ed366c8295f66fec"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a70d3f07111431a2aa3a804521c5c3a62a0647c53e07a3c8ff7b6e8eee87e7fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a70d3f07111431a2aa3a804521c5c3a62a0647c53e07a3c8ff7b6e8eee87e7fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a70d3f07111431a2aa3a804521c5c3a62a0647c53e07a3c8ff7b6e8eee87e7fe"
    sha256 cellar: :any_skip_relocation, ventura:        "8974e5c73c7a3ded036e2f4d23291ca2a11d5a42d1ae2d944425cfed1d69531d"
    sha256 cellar: :any_skip_relocation, monterey:       "8974e5c73c7a3ded036e2f4d23291ca2a11d5a42d1ae2d944425cfed1d69531d"
    sha256 cellar: :any_skip_relocation, big_sur:        "8974e5c73c7a3ded036e2f4d23291ca2a11d5a42d1ae2d944425cfed1d69531d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a70d3f07111431a2aa3a804521c5c3a62a0647c53e07a3c8ff7b6e8eee87e7fe"
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
