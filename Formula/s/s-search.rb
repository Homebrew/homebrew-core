class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "260df5364b947f19a12af9018cdeffecd5b572d1662ba2bbcbfba906c39330c3"
  license "MIT"
  head "https://github.com/zquestz/s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd28347437ccaac577e520058f36e31995d1fa406e7e4b17f5eee109d38313a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd28347437ccaac577e520058f36e31995d1fa406e7e4b17f5eee109d38313a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd28347437ccaac577e520058f36e31995d1fa406e7e4b17f5eee109d38313a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3952e5a7149cb4d195c85f551fa781a372b54d8890a1a645371a5811bdeeb90"
    sha256 cellar: :any_skip_relocation, ventura:       "a3952e5a7149cb4d195c85f551fa781a372b54d8890a1a645371a5811bdeeb90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "962819056e6fd782f24e136064609ab9ab5e4fe20b0e8efda38969f685e4dccf"
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
