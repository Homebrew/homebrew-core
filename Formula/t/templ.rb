class Templ < Formula
  desc "Language for writing HTML user interfaces in Go"
  homepage "https://templ.guide"
  url "https://github.com/a-h/templ/archive/refs/tags/v0.3.1118.tar.gz"
  sha256 "b4c5560a8148634e37030c3bce1a9d64a7f75657480a2725c3bd7b25f3aab5ad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7837d972e6d38e68b90160d97cf1fcbb487ea731f00fdc54104b6c6c1bd2d8cf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7837d972e6d38e68b90160d97cf1fcbb487ea731f00fdc54104b6c6c1bd2d8cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7837d972e6d38e68b90160d97cf1fcbb487ea731f00fdc54104b6c6c1bd2d8cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "081214543045c5e6ba313bebaeb7e9a5cc7ccd4862cf0dbed1a1f691975cf8a9"
    sha256 cellar: :any,                 x86_64_linux:      "4ffb628f970500dafc35b7d241abc4f4e78535687bcbaf896bba4c0225c4dc09"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/templ"
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
