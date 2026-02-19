class Srgn < Formula
  desc "Code surgeon for precise text and code transplantation"
  homepage "https://github.com/alexpovel/srgn"
  url "https://github.com/alexpovel/srgn/archive/refs/tags/srgn-v0.14.1.tar.gz"
  sha256 "5c06be7d74b1c50db2c80b8932733093e5ec35e75405762e7f5d7b0ba357ac06"
  license "MIT"
  head "https://github.com/alexpovel/srgn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24d0deb09e378f05ec390a40243140001ba46557ea1fa2203428eb30ceb11ff8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "349bebaeaea444ea878dbd960d4a0269d4003266769d7ac88cddd7d8254fdde4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ef03a5fae2f9319bf81262c6177975d02d28bb2676a6c42406ca99a2cc38a9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cb3bf13ce5e7e2104ab46e97b1415e4a0a4e1fb0c731facbf6b1e9f9675789a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84944201c3ad166b51663124e07b91fd91d5eeba049d774172c0e6e70bc6f7a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a954f1749207a971e0796d32f5042235999dce94bce725c67aba9fa4d022d3e7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"srgn", "--completions")
  end

  test do
    assert_match "H____", pipe_output("#{bin}/srgn '[a-z]' -- '_'", "Hello")

    test_string = "Hide ghp_th15 and ghp_th4t"
    assert_match "Hide * and *", pipe_output("#{bin}/srgn '(ghp_[[:alnum:]]+)' -- '*'", test_string)

    assert_match version.to_s, shell_output("#{bin}/srgn --version")
  end
end
