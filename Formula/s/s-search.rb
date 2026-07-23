class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "827cfec9a1f733354effe532130d4f241272bed4272e71ba91fec046960012c0"
  license "MIT"
  head "https://github.com/zquestz/s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8cf472a71c86dd579cf5c7b016da7d3ccf31bbb8016e7a77f2c4657b5887bbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8cf472a71c86dd579cf5c7b016da7d3ccf31bbb8016e7a77f2c4657b5887bbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8cf472a71c86dd579cf5c7b016da7d3ccf31bbb8016e7a77f2c4657b5887bbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "6510144d6bd31eab997e159b5dc101c6b80fc6b05e793b19afbf441322e3ff1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66628ab21bfe1f8ae64fc4bafc93d57b4f91aca1ab34f56ea02f53e1055d8053"
    sha256 cellar: :any,                 x86_64_linux:  "039a740d7b79b72c0def0357765e927cbe2e7531e3965ecfcf699e55ed8f6cbb"
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
