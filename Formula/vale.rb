class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.23.3.tar.gz"
  sha256 "d1fde826d1339b0b53f15264a82fe7a809d30c63629c898e4bb10f7329405110"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdb0dc61a8b7c231ebd300acaef55e35d1a303a3c235854b7daf624e56f91a9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61372ecc92b73b7e1c23752f918630e0ea5afb8ca95f36020a8080e88bdd3586"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2233c9ac5406ff046976ffc2b07bd1c284a6671b3b5d77e006c7a0d65692837c"
    sha256 cellar: :any_skip_relocation, ventura:        "7ca5421e204054892441ac81045afd21c6f334aea9fb251471451393c92c33e8"
    sha256 cellar: :any_skip_relocation, monterey:       "8dd33def4498c1ac88b2bf1ee263872fb5e2614256da735747e05debe1ad2fa4"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fef34c198a891c6d5baf5e5c4d8489fc2019fed34a1ea8c491d0d08b0170cdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db896b076faf091d890be110851e0fb867f03966b061a9f8a14dcc533f207a9a"
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
