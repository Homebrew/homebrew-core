class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/glideapps/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.1.3.tgz"
  sha256 "ba510542ac00f32d83cc1e574d959f057cec7a65fe665e44492fcee63f78a682"
  license "Apache-2.0"
  head "https://github.com/glideapps/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "430e8e3f8afdb7bd0b8e85b5e7eb431810ff651c44fc5d9f23eb4260fbfdb741"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "430e8e3f8afdb7bd0b8e85b5e7eb431810ff651c44fc5d9f23eb4260fbfdb741"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "430e8e3f8afdb7bd0b8e85b5e7eb431810ff651c44fc5d9f23eb4260fbfdb741"
    sha256 cellar: :any_skip_relocation, sonoma:        "2167e0279e6f8d8c0058b6cfa5d243f2d79757d8d5517c717ed5e86b55a893d5"
    sha256 cellar: :any_skip_relocation, ventura:       "2167e0279e6f8d8c0058b6cfa5d243f2d79757d8d5517c717ed5e86b55a893d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "430e8e3f8afdb7bd0b8e85b5e7eb431810ff651c44fc5d9f23eb4260fbfdb741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "430e8e3f8afdb7bd0b8e85b5e7eb431810ff651c44fc5d9f23eb4260fbfdb741"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"sample.json").write <<~JSON
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    JSON
    output = shell_output("#{bin}/quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end
