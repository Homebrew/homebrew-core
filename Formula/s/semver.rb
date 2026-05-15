class Semver < Formula
  desc "Semantic version parser for node (the one npm uses)"
  homepage "https://github.com/npm/node-semver"
  url "https://github.com/npm/node-semver/archive/refs/tags/v7.8.0.tar.gz"
  sha256 "bc2abf58261499a56264e21c456c0c23805e91c2da502d3957e9de96f4d33cc3"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4acd29ded946c9898f5e4198ce4da5291a9be4708fbf91c97a26405657207fd5"
  end
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/semver --help")
    assert_match "1.2.3", shell_output("#{bin}/semver 1.2.3-beta.1 -i release")
  end
end
