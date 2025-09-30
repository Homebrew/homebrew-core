class Templ < Formula
  desc "Language for writing HTML user interfaces in Go"
  homepage "https://templ.guide"
  url "https://github.com/a-h/templ/archive/refs/tags/v0.3.943.tar.gz"
  sha256 "c0638098f9b44f687cfb87732e2103d398a9a08b5e7b743ee531b90cf4d06984"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a05f2a594f7bd8e559c4745bbcc9d33b96c2f67044e2de35d9355207e22c0034"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29c7d968ad0042f39269e61b8cf64056635302b66124c83fad1cb8a00f800716"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29c7d968ad0042f39269e61b8cf64056635302b66124c83fad1cb8a00f800716"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29c7d968ad0042f39269e61b8cf64056635302b66124c83fad1cb8a00f800716"
    sha256 cellar: :any_skip_relocation, sonoma:        "49a391dd82a9e897aeb19d1b5e95cd17c820e051a9ae4d1500b31acc100ce544"
    sha256 cellar: :any_skip_relocation, ventura:       "49a391dd82a9e897aeb19d1b5e95cd17c820e051a9ae4d1500b31acc100ce544"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6965248db6bf03a83addd3ae24c1be14e2e9ec91dae6903558c26a68dab64c8"
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
