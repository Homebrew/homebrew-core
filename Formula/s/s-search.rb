class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "4bddf2ff574b6c1af36929290986b351484ba643725ec0918c3c0c10461e326d"
  license "MIT"
  head "https://github.com/zquestz/s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "78b50016430687712f8b84e23faefdffbf06db097036ff1e2c34c9c7bdbd4bbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef8e90f1d4e31ecea6da0d63de25cd3eb4cef6f6108a43f70fff4d298c70dafc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef8e90f1d4e31ecea6da0d63de25cd3eb4cef6f6108a43f70fff4d298c70dafc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef8e90f1d4e31ecea6da0d63de25cd3eb4cef6f6108a43f70fff4d298c70dafc"
    sha256 cellar: :any_skip_relocation, sonoma:         "b0c6b8d333b9c3cbb579bd1f0bee3e80f44e5120475aba3f03e04a38b6d032c9"
    sha256 cellar: :any_skip_relocation, ventura:        "b0c6b8d333b9c3cbb579bd1f0bee3e80f44e5120475aba3f03e04a38b6d032c9"
    sha256 cellar: :any_skip_relocation, monterey:       "b0c6b8d333b9c3cbb579bd1f0bee3e80f44e5120475aba3f03e04a38b6d032c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3aa30916a1b90e20f0c6e12d03afa20a7e6f1d639bc3c8134daf501f08916f5a"
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
