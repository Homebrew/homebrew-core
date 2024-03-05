class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/errata-ai/vale/archive/refs/tags/v3.2.2.tar.gz"
  sha256 "ecd505661eee9ccddeee4227e96eeedd323573bb778a58a4c8dc6fd739142e3d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6763cf498efff116cd591ab229610df4544c01dc6e16076cd7990d6ba215bf63"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f948c181d56c96d4b4317441d68c329e296907325d7149d7ae496fc6766b7fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4ca71b3eb2931aceefcdc70b4f812d62f4f1aafa8df84de223dc1c46701b6cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "de06e23ab406e55ec7cf9cd559f06537d45eeacee9a642c91745761247b1df7d"
    sha256 cellar: :any_skip_relocation, ventura:        "180143aac39554f7de5d3e1a97bc78ebffe57d8721786e18cdba7e52370c173c"
    sha256 cellar: :any_skip_relocation, monterey:       "738a02566c688696e11a1c92fc8364592c5d8401073ccf0f70ac8db768eefbcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f257a4bf8c5fbce678cba16ed585af2466ef50541c12224e0862b42e9287de6"
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
