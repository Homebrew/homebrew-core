class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "9dd80e19b2287abf2689b8f9fd424fdfad9abdc51b69e3a550579db69d6c8f6f"
  license "MIT"
  head "https://github.com/zquestz/s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21d524309004a7a9d7089d8c1aa37a1b61960e5a83f76238d3e8a3c1c5fc5583"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21d524309004a7a9d7089d8c1aa37a1b61960e5a83f76238d3e8a3c1c5fc5583"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21d524309004a7a9d7089d8c1aa37a1b61960e5a83f76238d3e8a3c1c5fc5583"
    sha256 cellar: :any_skip_relocation, sonoma:        "93be088867f990931ec0843f461bee7fc3869c837fb1da600be6e56d36bc2e69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "154883366e875db93c8101d19b19716b30cfd1930fc00e09c0900eabc799d420"
    sha256 cellar: :any,                 x86_64_linux:  "7e64c6426a2309018eea5aafa4a62259271c66d971326a3fd02ed7eb1a640c7e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"s")

    generate_completions_from_executable(bin/"s", "--completion")
  end

  test do
    output = shell_output("#{bin}/s -p bing -b echo homebrew")
    assert_equal "https://www.bing.com/search?q=homebrew", output.chomp
  end
end
