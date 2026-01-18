class Templ < Formula
  desc "Language for writing HTML user interfaces in Go"
  homepage "https://templ.guide"
  url "https://github.com/a-h/templ/archive/refs/tags/v0.3.977.tar.gz"
  sha256 "fbad3c9e2b6d9b551b1831de30b450d0735f4a9c0773f4f92fb1a16d1243af46"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0eba12c5f7b6adc357649697322f5d30648272f3ef4420ab879276eeb36abf2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0eba12c5f7b6adc357649697322f5d30648272f3ef4420ab879276eeb36abf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0eba12c5f7b6adc357649697322f5d30648272f3ef4420ab879276eeb36abf2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2f1602f8b2629a9320c1e1483c543fae06ba79e11964960d7a40e8d16ce65fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f8f9a349cbac87176887b21fa7be925be4b1fbaccb42ef6f6a7359d9b05b105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8af33b188adf6df5a85708aceeeda85716121eb3eec6dd60c9e12372a7c4e413"
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
