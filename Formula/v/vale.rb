class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.29.2.tar.gz"
  sha256 "a30634199d01f9fbdbada000029e444bd54b0e3c0af6a9619e0b17abf7a63e31"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3a9bef8cea529c0b4f36800f16fbb1096061e7259ad5a70e71cf44b59faab59"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdf45e2dcf3926f4bc4498ac6e1385ccaa56b413d4f2c9253a3ac08223545724"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c36f57132d1c79c664f536d567f28a19bdf923291855bb11b6fbdac4c0bd448"
    sha256 cellar: :any_skip_relocation, sonoma:         "11aee6b81805e8460a57a521518713e76f30b5e0410ca569b4f42268f804549f"
    sha256 cellar: :any_skip_relocation, ventura:        "05eb26f56c7eaccea89e27de0876e7205f5ea4dfc0eb52ad140c2d3543bd3dc5"
    sha256 cellar: :any_skip_relocation, monterey:       "5b862cb8f90eb7edc7cbd2184447c1ddf601aa2f1d79b9b769a928414a9f4c3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84a9eed1a212f675f706c48fb04fed052551e0e87a8b44bae50b067ddcf000dc"
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
