class Semver < Formula
  desc "Semantic version parser for node (the one npm uses)"
  homepage "https://semver.npmjs.com/"
  url "https://github.com/npm/node-semver/archive/refs/tags/v7.8.6.tar.gz"
  sha256 "4090fb28b4763cea3353001e455a4f089ceafbee4903c09d3a14f8586cf5c0d1"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a682fdb786908cd6c1b692aedf3d7282ac66f180f5ffd6ff70cde491581f4df0"
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
