class Templ < Formula
  desc "Language for writing HTML user interfaces in Go"
  homepage "https://templ.guide"
  url "https://github.com/a-h/templ/archive/refs/tags/v0.3.1020.tar.gz"
  sha256 "4f21ea4f1b60d65e506fa146a33a9d83d055c6f1e2e7687421f08ada6614d83c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ef351ab22cb0bc67bec76950159a8c5259a5e27acdaf4d21e001527144613a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ef351ab22cb0bc67bec76950159a8c5259a5e27acdaf4d21e001527144613a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ef351ab22cb0bc67bec76950159a8c5259a5e27acdaf4d21e001527144613a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d068b9223dcb79e205cb4c01ae9f75be0bf4a49f0457cb496292c3fc745b1104"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3e65a6a7863819faa7b791383afebaecd8a298ee0937f968fff3c4bab656ddf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d38cf8ffa6099a2b455a9c44f6a7190cd6a46734bb947f28838317eb260c88a3"
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
