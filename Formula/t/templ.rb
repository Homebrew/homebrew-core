class Templ < Formula
  desc "Language for writing HTML user interfaces in Go"
  homepage "https://templ.guide"
  url "https://github.com/a-h/templ/archive/refs/tags/v0.3.906.tar.gz"
  sha256 "0a31891f20448209a232beb35edb30892fdd49b43efb119eddd4488b71d5731f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2369906ae3f750d3094635fe33c8ae3ec0b5d5e646c44602b8665258eeb2dab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2369906ae3f750d3094635fe33c8ae3ec0b5d5e646c44602b8665258eeb2dab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2369906ae3f750d3094635fe33c8ae3ec0b5d5e646c44602b8665258eeb2dab"
    sha256 cellar: :any_skip_relocation, sonoma:        "a317b26c379fdf6a72ed54d818794498d1475a14e598c4c04273414393f84051"
    sha256 cellar: :any_skip_relocation, ventura:       "a317b26c379fdf6a72ed54d818794498d1475a14e598c4c04273414393f84051"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc29e24659c290f61effc35212affd5b4540ba4dbcd5402e25290c1374d8f9cd"
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
