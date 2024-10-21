class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.0.25.tar.gz"
  sha256 "7c0e1ca1d1cfb93490dedf4e5aa8c4d16bb6ee88a2db1269802b2657dc6fba83"
  license "Apache-2.0"
  head "https://github.com/refaktor/rye.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3230b9f0f0f31157db7acc03a9c6628691830667333e0a1c84ba1e53ac4d058a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5af550f7887cdd71b3be62dcc806bf33959f677224c538ba33642b416ae4be18"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ee7a626d912268c6695c8f74470eaa1b5b6ada25bc90e808f9d7da0d5666c5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "228cca683e2a7212e2d755a1dfc617415daa46d50b9d04c8bdd1f546a82b6e0f"
    sha256 cellar: :any_skip_relocation, ventura:       "536cb26f2aa775d90ee519780be32c7c84248d85445a2751ff1fe2e5fbce684f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75321650d43bb28083e9d56b5b849aa5a5e964ae4188d5640d9ca68c5a0d27ad"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"hello.rye").write <<~EOS
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    EOS
    assert_predicate testpath/"hello.rye", :exist?
    output = shell_output("#{bin}/ryelang hello.rye 2>&1")
    assert_equal "Hello Mars\n42", output.strip
  end
end
