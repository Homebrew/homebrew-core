class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.28.1.tar.gz"
  sha256 "fde7e2d1d79c927f0d36a4d2b5fadff516db8285d88363cf7af34239512c084d"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c81af5b058c43087e6343f02b7bba15a0ae4a14c65808fa1393b78b3547ba7f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29be87494b289cafe53a4a668ae2822d63759d1424cea1d930080f119fba443f"
    sha256 cellar: :any_skip_relocation, monterey:       "2ce02a5fa5d6c24066e37ecd4ecfec498ee88e6d47714fa06bd3a61bde068a7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "34b405fa60f83954e4fea597443333d0cf3cbc2923e4fb2fd3b9fae04e9c7f89"
    sha256 cellar: :any_skip_relocation, catalina:       "cb1e207ccccf6b9cc7c92cfd2c586aba2ecfb9afc9172f02cdfdc5e522a9b414"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f40ec294198b1162515a830d0170fb87626712ef797f845a59c21db30ed2c618"
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
