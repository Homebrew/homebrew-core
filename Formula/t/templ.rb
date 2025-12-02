class Templ < Formula
  desc "Language for writing HTML user interfaces in Go"
  homepage "https://templ.guide"
  url "https://github.com/a-h/templ/archive/refs/tags/v0.3.960.tar.gz"
  sha256 "61c1d8fe51c6351be10977e69049787eae44aa1fa7c09bfac493c80a1f884dae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5871f3f6a56e89e8cc808917542723963ddc39c60d940356afa51c6cb742057"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5871f3f6a56e89e8cc808917542723963ddc39c60d940356afa51c6cb742057"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5871f3f6a56e89e8cc808917542723963ddc39c60d940356afa51c6cb742057"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0656f2d51b518adf724c8729971db695cdffe560af475ac6a07b37a23035f4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbf42e75d9d672142875ee5bd63a9e1ce4027777910d1459befc4ec12a851365"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63d98da9d9d73e96a7451977fdef3b670bf2dd875a521aa45f7a458909322975"
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
