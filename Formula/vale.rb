class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.15.1.tar.gz"
  sha256 "2bbae984b4fc612a1d49c10b31d08899554c3410c74b5c28691ce0ac3d1a9e7b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c83ae1f476dac5138217240bd04a8263cdc1505e7ca8bd41a04d1ca4e26c480b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7365567c4b3924d2cb215a1733b37018fb0fbc7e7790039365b016784e1c025a"
    sha256 cellar: :any_skip_relocation, monterey:       "90dcee0384ba9e568b37cae1b753db263e21fc4295b80c62c8048986cf303df6"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfbd0a21dc8cef58fae4f660a026a2e06c342a2705e029f2bc3d942aeef0cf02"
    sha256 cellar: :any_skip_relocation, catalina:       "e7866b13b10afa828b6f831740a9bf3322ec12b4178e5fc63ed4cdb9312a3db5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbce9d9df09c03dca6c02dae7b3874d1f61368221e9f254871ac741d9e2ef1a3"
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
