class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/refs/tags/v4.41.1.tar.gz"
  sha256 "25d61e72887f57510f88d1a30d515c7e2d79e7c6dce5c96aea7c069fcbc089e7"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5404881e9aba4d22663971dd620f7e8bbd2bbed07d6623ddcb06b8108eb8271"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab37a388dac49f8aa1dee95154cf840cd4c23cd8756cf394dc629e647d908c8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8580ba4cd20a0d5610dd253d91689d1fdacb5eb792ec2115713921524b8eb4ad"
    sha256 cellar: :any_skip_relocation, sonoma:         "db2d0b23fcae3685db08dc78b67c592166ec4311f6058aad40fd984face94e60"
    sha256 cellar: :any_skip_relocation, ventura:        "823638d8a82d905fcd00c7e88b12cfe6ada9e9e4a9ea627cfb37d55965648354"
    sha256 cellar: :any_skip_relocation, monterey:       "87ff086af7864d8419c519642079d6923cbc7931250faa39dd0df44a58ffcaf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c42c4894c4508bd6af2551dd07e5fe5646fe0ecb25d0a96931a263b5a46fdc1"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Install shell completions
    generate_completions_from_executable(bin/"yq", "shell-completion")

    # Install man pages
    system "./scripts/generate-man-page-md.sh"
    system "./scripts/generate-man-page.sh"
    man1.install "yq.1"
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}/yq eval --null-input --no-colors '.key = \"cat\"'").chomp
    assert_equal "cat", pipe_output("#{bin}/yq eval \".key\" -", "key: cat", 0).chomp
  end
end
