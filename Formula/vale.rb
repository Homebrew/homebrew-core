class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.27.0.tar.gz"
  sha256 "65de0683d653767da8ef9f58fe3bf5978263978db4b98ee9609d7b90f2c4f4dc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5bb5f6d4be5c3e31cdef03f02daef0cb4a6f3424f0b80cc62f387b4db8c72010"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bb5f6d4be5c3e31cdef03f02daef0cb4a6f3424f0b80cc62f387b4db8c72010"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5bb5f6d4be5c3e31cdef03f02daef0cb4a6f3424f0b80cc62f387b4db8c72010"
    sha256 cellar: :any_skip_relocation, ventura:        "f90876b21a8445e9b94d05f3db9acb524e7586d1736cb2df1ad159f43a74888c"
    sha256 cellar: :any_skip_relocation, monterey:       "f90876b21a8445e9b94d05f3db9acb524e7586d1736cb2df1ad159f43a74888c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f90876b21a8445e9b94d05f3db9acb524e7586d1736cb2df1ad159f43a74888c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fb98ff4e996907a8b91817fbf2a5838132e9d496ed36439d473a636b77a3ce7"
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
