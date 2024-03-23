class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/errata-ai/vale/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "07dac0e876382afedaed0f5a266a95f0633b80130fc4e1f472885756adf46ed7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0de722f9f7efd480beb3622fdf376c0d0df32aca90552c2a50191d411e17bc8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "879c013adfce58dfaca87d4230a168f5f05877a9b83de7f60e82a08413a1b39c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "baf319760ce7adafe8b22a18812e4fbe697fd756f1e334657642a77409f3c310"
    sha256 cellar: :any_skip_relocation, sonoma:         "945022e200282d308b38ccd2c85ea605040dba36d8359b80336bb1aadbed6f73"
    sha256 cellar: :any_skip_relocation, ventura:        "201f2f0788abfb1933b5348453344ad21a87f7de85c042a8e7b3b6ab317a6941"
    sha256 cellar: :any_skip_relocation, monterey:       "da51ec3e3a4f41b178d1eb966710b6566d59dbcad593bb80bade9797406943fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2af24662cd8290abcd20f58658a2564c8c5c034e754cc427c6c4673177a4c0ba"
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
