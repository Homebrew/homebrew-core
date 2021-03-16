class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.10.1.tar.gz"
  sha256 "43f5552ab9a2a972151f9aa5516fba27486007fde2ea6d19a6e0ffc965a3ee4b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "26c9d07e16db052d2a3511f73ffa5b51e6be79631ddb4060cf6b0f7d752d7b85"
    sha256 cellar: :any_skip_relocation, big_sur:       "a45512fb3ec59ef453d3f4395913334a2a2cb37363df7f22d0ce2e9be1f0fce4"
    sha256 cellar: :any_skip_relocation, catalina:      "d665612b660e7915e78dde90a6bee035377f9bfc449bcf437c997a7ce5b0b04b"
    sha256 cellar: :any_skip_relocation, mojave:        "9da91f3431083b08d1d0ad97a7e0f499764627e21684208f0d0d0355b0de4be1"
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
