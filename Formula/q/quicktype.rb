class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/glideapps/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.2.3.tgz"
  sha256 "c67556f876026b556fe7c39ca667e19c9b206a6aef579a670e6b1d81864c2756"
  license "Apache-2.0"
  head "https://github.com/glideapps/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8b618fd6acf18dfe395bacf8eb05e0da1a094ddcc870650d765cc69c9cc8e70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8b618fd6acf18dfe395bacf8eb05e0da1a094ddcc870650d765cc69c9cc8e70"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8b618fd6acf18dfe395bacf8eb05e0da1a094ddcc870650d765cc69c9cc8e70"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9daca20a82198b711a79a2bdf8fbc62dbad8dc7c45226a469efe12733ace7a7"
    sha256 cellar: :any_skip_relocation, ventura:       "c9daca20a82198b711a79a2bdf8fbc62dbad8dc7c45226a469efe12733ace7a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8b618fd6acf18dfe395bacf8eb05e0da1a094ddcc870650d765cc69c9cc8e70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8b618fd6acf18dfe395bacf8eb05e0da1a094ddcc870650d765cc69c9cc8e70"
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
