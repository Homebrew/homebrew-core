class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.29.5.tar.gz"
  sha256 "7804190b5a7f6bc0935f3b3f94c520c04a27cbfb63129d4dfae948daa28a5627"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec9af4c30544b081078f531a640c9c7643bd5499da45d5432b0185812e6757ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fea6edfe974cfddf139bd9bc4484eb342d7078b800b70fc5260760f9cbba47c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3e29c266eb9092885a195c85a1a6a2cd84d5ee81228b82748cbc4828bdb1e81"
    sha256 cellar: :any_skip_relocation, sonoma:         "9de699e3fbb5a1b52f1d824f8f7c8c5e1044e549ac592844ff56c051b99826bb"
    sha256 cellar: :any_skip_relocation, ventura:        "62b3d6b4fd61437cb2a5df5ff75b0962319855582720224aa323037d5ec22a45"
    sha256 cellar: :any_skip_relocation, monterey:       "97aaa96860e95815ab953e0d766cc09d354d532b50b7230e2f742734007ec366"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aedaa2dc5a5f7f3b22027a2f2092a0cf0c6c6622844dfb870f5da01d6a0fd953"
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
