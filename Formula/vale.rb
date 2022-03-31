class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.15.5.tar.gz"
  sha256 "157cdab83eba405da4301b3ed3aa1e5cea085dd32dd212494df2cc31245706da"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c35fcdb9b744dcec1bba9db20bf9515a10bcbd59a6b430ffe60cb7a3c91ab6ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8a2c42bdf49b0db3fc6ff0074f1a005c02904bd83a0aa887e4fb74efbd1fe6a"
    sha256 cellar: :any_skip_relocation, monterey:       "c8c860beb9ba7cf0bba30ec409871d545546c241c159cbb98fd6c1bf40432284"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c52889c4428fcb2eb73f9c285a24e29be0feb5cf3fca1ba834ca80bcf58a5c3"
    sha256 cellar: :any_skip_relocation, catalina:       "2df26407d12ef80cbb49ca2077db15cdadce7d416b6a92e7991ee0a23b7deae4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b2094cb8521d9212e0e7179ab5b443d9e6acc71589fe7e99c7cec8d6f9a865e"
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
