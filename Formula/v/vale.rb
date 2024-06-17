class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/errata-ai/vale/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "13a3b0ef4ba9f0e89f663d7f6ba65facd2fca37333e97512c03ac807e413afe0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b82a879cb24f8c551c8b3baa9fa65c0602cf2bef600c765faf2735de07eaaa82"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0f29b13d0470be4226368ad8e8efc2f4f755da3fd06bb3016755a16e4d67e2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52e4ad39af72d730e581c03683c041206f1cf81c2fb09c20b6d9db2d7fd35868"
    sha256 cellar: :any_skip_relocation, sonoma:         "30d2f0c1e5d0d14d3bdc14135581beea10a36e6fdd865eef914e9a0a21b41957"
    sha256 cellar: :any_skip_relocation, ventura:        "2a4412d5433b469a5dd3fa60027e4f28da6bb01746f25d0799ed06d848d5729b"
    sha256 cellar: :any_skip_relocation, monterey:       "5e739a3da15c14187997bf6f63981a2d683d446ac7c29c14722d701cd1af03d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7428c29662786da25c46deda32594704f910eb4867abdcc7e17b308ef6978002"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args, "-ldflags=#{ldflags}", "./cmd/vale"
  end

  test do
    mkdir_p "styles/demo"
    (testpath/"styles/demo/HeadingStartsWithCapital.yml").write <<~EOS
      extends: capitalization
      message: "'%s' should be in title case"
      level: warning
      scope: heading.h1
      match: $title
    EOS

    (testpath/"vale.ini").write <<~EOS
      StylesPath = styles
      [*.md]
      BasedOnStyles = demo
    EOS

    (testpath/"document.md").write("# heading is not capitalized")

    output = shell_output("#{bin}/vale --config=#{testpath}/vale.ini #{testpath}/document.md 2>&1")
    assert_match(/✖ .*0 errors.*, .*1 warning.* and .*0 suggestions.* in 1 file\./, output)
  end
end
