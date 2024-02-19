require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.104.tgz"
  sha256 "1dbe2b38861242620863e769be0253362d197db32352406caee6a73821b806c6"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e441557793483dc5a22e3bb02475979d93fd6dcc1a4b475a641fe332b2e6cad7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e441557793483dc5a22e3bb02475979d93fd6dcc1a4b475a641fe332b2e6cad7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e441557793483dc5a22e3bb02475979d93fd6dcc1a4b475a641fe332b2e6cad7"
    sha256 cellar: :any_skip_relocation, sonoma:         "52a73ace00a072ea7bd7501f2e70bd531b8b9c46293d963555be521884c83ecb"
    sha256 cellar: :any_skip_relocation, ventura:        "52a73ace00a072ea7bd7501f2e70bd531b8b9c46293d963555be521884c83ecb"
    sha256 cellar: :any_skip_relocation, monterey:       "52a73ace00a072ea7bd7501f2e70bd531b8b9c46293d963555be521884c83ecb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e441557793483dc5a22e3bb02475979d93fd6dcc1a4b475a641fe332b2e6cad7"
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
