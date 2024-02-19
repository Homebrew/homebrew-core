class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/errata-ai/vale/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "17722be52a8ab919e26adeb077818de47ef275141a047aee789c9516d9c96ea7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3988298cdabf5fcdae6a0ff97b7142585827756b984f0c78e3a083ea7fe83318"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6e429f599be615779ee0d79319ff64f35f3177eef8fc4d6eb7a255365bae2f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93123352b325116a4e1f5a63122661fc7fb22649eaa9c667ae22474ea6fe6ef7"
    sha256 cellar: :any_skip_relocation, sonoma:         "19497fe992e7e1b52082270ae35c19be82cbd5127a050c29f040590304e6a2e8"
    sha256 cellar: :any_skip_relocation, ventura:        "41312e16e5442b8c3ceb7fe9de2402a98ad9f1f8945e5129fe7c1ecb08507c63"
    sha256 cellar: :any_skip_relocation, monterey:       "8da770902613293f01f8b7134e0912ed1428f73bf158da9ca977580b5caec9e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ffae401fa6c1ce20e47c6e40438af51d94c5b40a7bf905296e50a073a072ced"
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
