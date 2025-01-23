class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/errata-ai/vale/archive/refs/tags/v3.9.3.tar.gz"
  sha256 "5ecf6ea4183e0c976bf5f391e296da833f173956fd6f9f28597f8e63af66e178"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90e365d1d6d637518671ddd45e90e936d8ee6088d09a7f58a95bee01f485ecb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fc4061192d2cb81b655f97b3a29c57e841cf2e2d504b910437e22f02139db08"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05683f21e6970d27c3d990f59192e605d0417f4c290d02a59cc8f5da292dd440"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ce5ca10e06ab9f4ef34312f5dfc1ae6a2a304159f99101310269fc7d890ba49"
    sha256 cellar: :any_skip_relocation, ventura:       "d51cefda197fb0be42868f718913c349a896107211aa2609cca570e6ec95144c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8434335c2ac04abe4018fb3cfe4691696381977f5a43d42f7c0c33c212ab6629"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args, "-ldflags=#{ldflags}", "./cmd/vale"
  end

  test do
    mkdir_p "styles/demo"
    (testpath/"styles/demo/HeadingStartsWithCapital.yml").write <<~YAML
      extends: capitalization
      message: "'%s' should be in title case"
      level: warning
      scope: heading.h1
      match: $title
    YAML

    (testpath/"vale.ini").write <<~INI
      StylesPath = styles
      [*.md]
      BasedOnStyles = demo
    INI

    (testpath/"document.md").write("# heading is not capitalized")

    output = shell_output("#{bin}/vale --config=#{testpath}/vale.ini #{testpath}/document.md 2>&1")
    assert_match(/✖ .*0 errors.*, .*1 warning.* and .*0 suggestions.* in 1 file\./, output)
  end
end
