class Templ < Formula
  desc "Language for writing HTML user interfaces in Go"
  homepage "https://templ.guide"
  url "https://github.com/a-h/templ/archive/refs/tags/v0.3.1118.tar.gz"
  sha256 "b4c5560a8148634e37030c3bce1a9d64a7f75657480a2725c3bd7b25f3aab5ad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f477fade0e1ab89ea6cfb55707c00d142172bd32aadddad09d84e6ee21fc8582"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f477fade0e1ab89ea6cfb55707c00d142172bd32aadddad09d84e6ee21fc8582"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f477fade0e1ab89ea6cfb55707c00d142172bd32aadddad09d84e6ee21fc8582"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9db93e6208ca2000a4e4975bde6a7f3693ea596cd0ad204c40f92ad4df0f5ab8"
    sha256 cellar: :any,                 x86_64_linux:      "f7f2ceedf55ce2045cf2349505aef0af522d9cea6e84c1f4a1e24c774dd4720e"
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
