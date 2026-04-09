class Templ < Formula
  desc "Language for writing HTML user interfaces in Go"
  homepage "https://templ.guide"
  url "https://github.com/a-h/templ/archive/refs/tags/v0.3.1001.tar.gz"
  sha256 "aa79ec1738beaa271cdc5a470176b6e2cf84c6db94b748e1e31d0628e9baf565"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2546912280488c8997ea7740e74b20167ff665b1f715fbd946640989a3685f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2546912280488c8997ea7740e74b20167ff665b1f715fbd946640989a3685f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2546912280488c8997ea7740e74b20167ff665b1f715fbd946640989a3685f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "836c8a67faa74a942231212f562dd5b28b51b297b4d6abe8a778e7008291e8d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1deda54c5e55e21dafac6f0a2a3be3422fb6e9270d3286b48956d5e90466c6d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e81c30ee347d543627fdd10dbbba838b47b1446944e175badc542f53a56627ac"
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
