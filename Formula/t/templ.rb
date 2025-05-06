class Templ < Formula
  desc "Language for writing HTML user interfaces in Go"
  homepage "https://templ.guide"
  url "https://github.com/a-h/templ/archive/refs/tags/v0.3.865.tar.gz"
  sha256 "62c9d64aa11f1783db06a27e8f8f649c762486b14f0c64ce08d3eeb4a1a06ec1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d24511ebc9f88569ef54178791d5f0ef2902c016cb5d0a0883c133518b4ee759"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d24511ebc9f88569ef54178791d5f0ef2902c016cb5d0a0883c133518b4ee759"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d24511ebc9f88569ef54178791d5f0ef2902c016cb5d0a0883c133518b4ee759"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3520fab888a182436be7f25932399c40d9b4023bf148dc0393d120ab31e83f6"
    sha256 cellar: :any_skip_relocation, ventura:       "d3520fab888a182436be7f25932399c40d9b4023bf148dc0393d120ab31e83f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f33eeb717191fa6ce337b4ed5233b422343ee8b42c265523a3cbf3ad6e02b569"
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
