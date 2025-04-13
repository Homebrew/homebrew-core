class Templ < Formula
  desc "Language for writing HTML user interfaces in Go"
  homepage "https://templ.guide"
  url "https://github.com/a-h/templ/archive/refs/tags/v0.3.857.tar.gz"
  sha256 "3f881de3baea1e90506ba9e89b1106cd3cc2c933345994ed3c4609a21c96ff98"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0c4a0b58e4562dfe32c72c078b4198dd21b33d813cc8cc863bd3552f15eeb48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0c4a0b58e4562dfe32c72c078b4198dd21b33d813cc8cc863bd3552f15eeb48"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d0c4a0b58e4562dfe32c72c078b4198dd21b33d813cc8cc863bd3552f15eeb48"
    sha256 cellar: :any_skip_relocation, sonoma:        "4eb7a21658c238b0e763d88e2a09b645b503ca63b6b520112e13be49dfdb8c96"
    sha256 cellar: :any_skip_relocation, ventura:       "4eb7a21658c238b0e763d88e2a09b645b503ca63b6b520112e13be49dfdb8c96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "778c32ca7f800e21ec2fb745b19d466d47c916a43eed9f4b417ca9fa7c5eb642"
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
