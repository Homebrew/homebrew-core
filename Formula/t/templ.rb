class Templ < Formula
  desc "Language for writing HTML user interfaces in Go"
  homepage "https://templ.guide"
  url "https://github.com/a-h/templ/archive/refs/tags/v0.3.1070.tar.gz"
  sha256 "feb6da339d812c80ee981539bf10b90f6b77946d6eec05cb6ef38b6dc2783c8b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2d1450e452c69c2d177a500b9d53db871e9354529861c115efd9d9793d78e692"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2d1450e452c69c2d177a500b9d53db871e9354529861c115efd9d9793d78e692"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2d1450e452c69c2d177a500b9d53db871e9354529861c115efd9d9793d78e692"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5692b1aeacacc723f66aa87da003a830f0e0d266b33d6ba1b6136d9ef15ad091"
    sha256 cellar: :any,                 x86_64_linux:      "a5e83a6255de4482863355235703ffa20747030cbc717385bdb89f2405fd22c8"
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
