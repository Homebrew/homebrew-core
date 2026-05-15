class Sitefetch < Formula
  desc "Fetch an entire site and save it as a text file"
  homepage "https://github.com/egoist/sitefetch"
  url "https://registry.npmjs.org/sitefetch/-/sitefetch-0.0.17.tgz"
  sha256 "eb65e7d0179e5c06f70a3071865cf8199827428adb64da19de12afaf682c0ddd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5f514ec63a1829bd85a7cb8f5aef1f4712ab83e21480f583a05d4e231f90ac83"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sitefetch --version")

    system bin/"sitefetch", "https://example.com", "-o", "site.txt"
    assert_match "Example Domain", (testpath/"site.txt").read
  end
end
