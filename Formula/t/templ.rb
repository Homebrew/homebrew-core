class Templ < Formula
  desc "Language for writing HTML user interfaces in Go"
  homepage "https://templ.guide"
  url "https://github.com/a-h/templ/archive/refs/tags/v0.3.887.tar.gz"
  sha256 "f78e0508d88249f44e2d82ff91bdf0e741d28e9a455f49d49a1cf7172766a97f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac98150e30faefa596c008080a1a6478c93bea6bfc654a6a97b1cc1c39f1f0f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac98150e30faefa596c008080a1a6478c93bea6bfc654a6a97b1cc1c39f1f0f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ac98150e30faefa596c008080a1a6478c93bea6bfc654a6a97b1cc1c39f1f0f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdf5e81813c005dd6c5bf15b29c6b053436f12305b32a45310c85d53755c8ad4"
    sha256 cellar: :any_skip_relocation, ventura:       "cdf5e81813c005dd6c5bf15b29c6b053436f12305b32a45310c85d53755c8ad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0236a383b54ef16e13710867cd7f8287c758176e9e810bcd10da7a96aa39ae54"
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
