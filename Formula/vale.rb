class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.21.1.tar.gz"
  sha256 "249667a6b12950b94236e6cb3cf776cc28e623d46bad03bb64e9db34d1f572fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "335f1455b48f22d15ac71e1baff2f2769f6f7833168034900e7e059ad515600b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb646a0fb6ab33c1b1c688bb377ade7c61f8fe0668ebb74dbcc5175f72ea0312"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a58fe03bccc75f05b68236952d8bb3d921d11a1f2f30408a84192e70837f295"
    sha256 cellar: :any_skip_relocation, ventura:        "668d93aa20be09cbd036e9d94d504d4976e3e1a6fa32f20904d99c3990e40a9a"
    sha256 cellar: :any_skip_relocation, monterey:       "8d1626b8384d727e608a93b125cafeb647ac2e64a0d59b1269cc194bddc02a80"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ad77ae89f7f0aa0cd3c110e83ffbbe763d8cb1337826f083865b1808613124b"
    sha256 cellar: :any_skip_relocation, catalina:       "eb974e2d460b53b7e08b9d76a6877db46d768565c3fa27c926b5a5564e032bf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c8458995de52e5974d869870fe62de758d725d358135a73de4b2035fe744441"
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
