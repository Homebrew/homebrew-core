class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "260df5364b947f19a12af9018cdeffecd5b572d1662ba2bbcbfba906c39330c3"
  license "MIT"
  head "https://github.com/zquestz/s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccaf69d22c12a51cba1b0ae664c81e8ff029d96ee2e96af9bf3c15f0b56ec12a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccaf69d22c12a51cba1b0ae664c81e8ff029d96ee2e96af9bf3c15f0b56ec12a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ccaf69d22c12a51cba1b0ae664c81e8ff029d96ee2e96af9bf3c15f0b56ec12a"
    sha256 cellar: :any_skip_relocation, sonoma:        "82373b628e5452657050d45033e34c8c9225c0ca0d3baa34ce5288011a15e159"
    sha256 cellar: :any_skip_relocation, ventura:       "82373b628e5452657050d45033e34c8c9225c0ca0d3baa34ce5288011a15e159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "870ac87d10e778afe2c447da431d1828d9c25b05a815096c69a11801dfaf8833"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"s")

    generate_completions_from_executable(bin/"s", "--completion")
  end

  test do
    output = shell_output("#{bin}/s -p bing -b echo homebrew")
    assert_equal "https://www.bing.com/search?q=homebrew", output.chomp
  end
end
