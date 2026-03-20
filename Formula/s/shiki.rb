class Shiki < Formula
  desc "Beautiful yet powerful syntax highlighter"
  homepage "https://shiki.style/"
  url "https://registry.npmjs.org/@shikijs/cli/-/cli-4.0.2.tgz"
  sha256 "a71b72ee1e8ed1c3f92ff97ea3a4d10db4f428b40e265ebaeea8ccd003ee9638"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4982b6dca9dac0148a63f697a8540a5c57609f364b9aa88c6645c80adff13477"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shiki --version")

    (testpath/"test.txt").write <<~TXT
      Hello, world!
    TXT

    assert_match "Hello, world!", shell_output("#{bin}/shiki #{testpath}/test.txt")
  end
end
