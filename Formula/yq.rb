class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.27.4.tar.gz"
  sha256 "6a313a6855814080a37e9433fe883c064de567c18cef29f07e7b817cf3295e8a"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73ab89282b06b1e82776f405351dbad5aa4d78987e9f764e82879426eca26bfe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a7896f8b06a74d00bf3a975afdb48cbee2044818d08e1e356861e54ff2d5c5b"
    sha256 cellar: :any_skip_relocation, monterey:       "7bf58ff88069758b0a5d16b6d21141892ea7a50ea5f89261969397591a98ee89"
    sha256 cellar: :any_skip_relocation, big_sur:        "256f81c0b0118a6b22617c9f673ef4b151c069c423b6255f15a9d6d465686eba"
    sha256 cellar: :any_skip_relocation, catalina:       "ca8b1a7ed73df03707fb883d8dab1f960724ecb41f6776ab57fa7286e4b68fc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b8fb8da1f017a043dce6058664083cb74529cf482a4d861ebadb7ca0b9c2365"
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
