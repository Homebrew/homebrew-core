class Typtea < Formula
  desc "Minimal terminal-based typing speed tester"
  homepage "https://github.com/ashish0kumar/typtea"
  url "https://github.com/ashish0kumar/typtea/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "d2c5580b46c39189b28de3fde92ae51a811efc063a1d819bbc2db359a7c34f98"
  license "MIT"
  head "https://github.com/ashish0kumar/typtea.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34762664901bd215ea8d9bfc390daa6ccfbedd6c3d511abab0867de8a27e1aa5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29331a5f5f84fbdbf6d724163f70bbcce0bba015850e62f8e4185292b661dcc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29331a5f5f84fbdbf6d724163f70bbcce0bba015850e62f8e4185292b661dcc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29331a5f5f84fbdbf6d724163f70bbcce0bba015850e62f8e4185292b661dcc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7993fc19824a6841a296131340db8f5d9d40e0b92b599ea095e1586db409dde"
    sha256 cellar: :any_skip_relocation, ventura:       "b7993fc19824a6841a296131340db8f5d9d40e0b92b599ea095e1586db409dde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07ea14d623844b30f7e212f3eb32717c6cb9d72fbf1da52deb37c71134f613ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d9099d3a169a377f90f6b9c703d1f8403f60d12bc77500c79d5157350ab6a14"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/ashish0kumar/typtea/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/typtea version")

    assert_match "python", shell_output("#{bin}/typtea start --list-langs 2>&1")
  end
end
