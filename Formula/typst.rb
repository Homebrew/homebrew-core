class Typst < Formula
  desc "Markup-based typesetting system"
  homepage "https://github.com/typst/typst"
  url "https://github.com/typst/typst/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "97bc0f62d373595ace556677e581daea5845bac18863ff014ced3bf8e650d94b"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/typst/typst.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ad9f3c91c07ac9af359cc4d4bf090ed92735d09adf9f7c382c83bf69b822b41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d5544839b4898b12799832d23edd50953734af7c93a32a2d1b7ba8aa2f05dbf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71068e8852a7300cb85e8000e9cc4c74ad62ab55b89beef4ccb97a6dfbd6e5c2"
    sha256 cellar: :any_skip_relocation, ventura:        "36549ee06d68760fea3765f2e4d39b234d1d4b3229bc9e6baf16ca2afb36001a"
    sha256 cellar: :any_skip_relocation, monterey:       "9ffdefed3a8795735d9c387c54892a0ff160b9d8513c5c6d9dd14b3adea51237"
    sha256 cellar: :any_skip_relocation, big_sur:        "ecbf5ab1d1a0f8548ba06c99b970ff9bdaa2e3c9b9e4f999bc5a28b5262ef444"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30a5f56905b05c73e752c45b0b7bb9ee3223555b215f7f75273db4fb5706f9e1"
  end

  depends_on "rust" => :build

  def install
    ENV["TYPST_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    (testpath/"Hello.typ").write("Hello World!")
    system bin/"typst", "compile", "Hello.typ", "Hello.pdf"
    assert_predicate testpath/"Hello.pdf", :exist?

    assert_match version.to_s, shell_output("#{bin}/typst --version")
  end
end
