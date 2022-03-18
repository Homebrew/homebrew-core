class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.15.3.tar.gz"
  sha256 "767c3c271b733e76c84e5e5340eb25d05fa06606bdbbb7f4eb94a224d9fceb6a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca67e63a9ee59c5cfaa7484f58ce40b84f812e249c6d47f3901fcc33c83c9574"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab51250df1a586d214ec5131a784475ae6ebeddd0cacb99b17652a815b52e5bb"
    sha256 cellar: :any_skip_relocation, monterey:       "0f1fb0e1313a831cc700d097c0f5fa28679ce8c43a226faa6ac78235f70bf63a"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a013682419dcedf7cf3bc13dfd28e3a030004d5dc9d8ece8dc1e44712ff914f"
    sha256 cellar: :any_skip_relocation, catalina:       "7557c259a8a7384de9c9268fbd1633023f6f3e24c7fe6b9b02691cbdb1cb9e20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98bd7d2070807da95c256d543c39dc99479b6e8640fa66f78f244454f3da2d0a"
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
