class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/errata-ai/vale/archive/refs/tags/v3.4.2.tar.gz"
  sha256 "e1696739f13c8b579d96a9e4df4592f0bbda167aa74872eede6cc9482374d32b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6f250a0471324535feac12638a63ec393a14d57318827258b6c2fdd4c4eef62"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2edb3ac3f5c30b0f6c66f37b425122168d9c0af63d58dfaa8cc66e24e25ec3e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6917c94d9354c55d3708cb6e74af76220cad2e7eb27ca4564d1001a1d0623e64"
    sha256 cellar: :any_skip_relocation, sonoma:         "765ba253b7f1e5f92c73c38cf0c5595c838d8ce11dde3c814096d2ef9ed1cdb5"
    sha256 cellar: :any_skip_relocation, ventura:        "0a2602323e195730c89a54f65771f92035d029f9a9cd991c6cc4d62567116668"
    sha256 cellar: :any_skip_relocation, monterey:       "2952d5604f2f6e339d62a42e6d8dd9ce5f9039c97615e23bc4a679d381275706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa4c6dfb80c2d3937626f90ce51a543bb93b8c58f91dbaa0ca70a8c85113dac5"
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
