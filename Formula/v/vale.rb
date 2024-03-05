class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/errata-ai/vale/archive/refs/tags/v3.2.2.tar.gz"
  sha256 "ecd505661eee9ccddeee4227e96eeedd323573bb778a58a4c8dc6fd739142e3d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bba12d39ec1f0d9bf6183c0550a7314a54e990576e3b2e4ba61d148c73d10822"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd4c0bef2e664d253264b5eec5bdf29c66f9f88be9aa453c1cd165dd2863bd50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6fba8c3ae28b2e7aa0ba07ce98d8dc3ccd0c4dcd9ab0c381d9ced1f6d0aa8b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a6aac9d81c70072059844fb18f6f646249f4ae7fc92309bce7d50fbc2bd8768"
    sha256 cellar: :any_skip_relocation, ventura:        "04e3290b69bd47337630e92aef3c2ec139498bc480df678cb5c30bd0738237c6"
    sha256 cellar: :any_skip_relocation, monterey:       "6e1ab8e37f148b982cb259c4b39064a9090cb8c3427319a41920465061286c76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0917a48c14fb9aa7d982c1e310b83081f35ca77f35d2d27d91d466af13137684"
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
