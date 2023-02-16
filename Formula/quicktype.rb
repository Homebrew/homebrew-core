require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.0.tgz"
  sha256 "4c4dc5465f59a0bb1a9fe6e67d6388a2502193d7e801b07db27e06fe9b41eb82"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c14b9f536b473d554e3770913f48bbaf1211e2a406220839242750c37547542"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c14b9f536b473d554e3770913f48bbaf1211e2a406220839242750c37547542"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c14b9f536b473d554e3770913f48bbaf1211e2a406220839242750c37547542"
    sha256 cellar: :any_skip_relocation, ventura:        "c4315b06f9c3e87a44bbea29cf1f31258001519d9b8e0b8b56090fb9e454920d"
    sha256 cellar: :any_skip_relocation, monterey:       "c4315b06f9c3e87a44bbea29cf1f31258001519d9b8e0b8b56090fb9e454920d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4315b06f9c3e87a44bbea29cf1f31258001519d9b8e0b8b56090fb9e454920d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c14b9f536b473d554e3770913f48bbaf1211e2a406220839242750c37547542"
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
