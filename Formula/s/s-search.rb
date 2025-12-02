class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "c491ddb6306382bba7ab2665b6fddbb60aef3de32704c04549a5e0b0174dfa6d"
  license "MIT"
  head "https://github.com/zquestz/s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "763f136162738c6f4d9ae054b1413f9a6102f07ad7e03d51df0321d2eb9bddca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a96038a526b7e96243e6ecc888797e4a251808d743e8ddb45f2d5681c30317de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a96038a526b7e96243e6ecc888797e4a251808d743e8ddb45f2d5681c30317de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a96038a526b7e96243e6ecc888797e4a251808d743e8ddb45f2d5681c30317de"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bf4deb4ed35aa297709f7a4b11b8cb906d2092de15b1f19472978d901607894"
    sha256 cellar: :any_skip_relocation, ventura:       "8bf4deb4ed35aa297709f7a4b11b8cb906d2092de15b1f19472978d901607894"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33ab9d9046453f31145cf049ca2f93a46601dd835a8aafa518867f931067d413"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf9a65a9868df6359142ed3c53e24d7471935c96948d3251ff660b8d4599d7ea"
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
