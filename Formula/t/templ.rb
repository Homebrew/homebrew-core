class Templ < Formula
  desc "Language for writing HTML user interfaces in Go"
  homepage "https://templ.guide"
  url "https://github.com/a-h/templ/archive/refs/tags/v0.3.833.tar.gz"
  sha256 "f9275bff1d92f4342c8337275aba0d5aec567c13747c0eb8ac9c72d6a46c0ec1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcb7c5d0e30b54f7fd24a28b819af6c3dcef1577b959f65866b7cf66c196d3a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcb7c5d0e30b54f7fd24a28b819af6c3dcef1577b959f65866b7cf66c196d3a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dcb7c5d0e30b54f7fd24a28b819af6c3dcef1577b959f65866b7cf66c196d3a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2fa6066c23382f52a75f65cc2d721debb970b008705228f5b28187871c0e650"
    sha256 cellar: :any_skip_relocation, ventura:       "a2fa6066c23382f52a75f65cc2d721debb970b008705228f5b28187871c0e650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f14dd5a17dd80c463402447d8faba3afeda21dd362cb964ae432b5cda52189aa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/templ"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/templ version")

    (testpath/"test.templ").write <<~TEMPL
      package main

      templ Test() {
        <p class="testing">Hello, World</p>
      }
    TEMPL

    output = shell_output("#{bin}/templ generate -stdout -f #{testpath}/test.templ")
    assert_match "func Test() templ.Component {", output
  end
end
