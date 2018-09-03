require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-15.0.120.tgz"
  sha256 "6586219b9e18f35a8ce5b8b8c97889ac82bf4eee56d67d68852e7443c8235f1d"

  bottle do
    cellar :any_skip_relocation
    sha256 "5845f4eb51875a6634bf74fc67707686f6af005f2253ab7d080d40f6251b52fb" => :mojave
    sha256 "ba2108f7999343086dd9ceb2b012a937c98d870e5aadfed90388e6b1fdeef25c" => :high_sierra
    sha256 "c5541eacbe37198f8f93fe0027ec925ede061354ababc0530e7de0914f252921" => :sierra
    sha256 "65da485e00d53b85d3b040642f42bcecfb98dbca37edf3375234edd37241b099" => :el_capitan
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
