class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.29.2.tar.gz"
  sha256 "4a349c7858793463555c12df698757265a3e46d6b107adac75fabc46d9591df6"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8461be177a580569f9f12cf4dfef91a062e49051724377f7ff99e4dad077eedf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63a7095cb22cfb12674753702cae59c55fc2cb795b6bc18d358bc9491eb7fe9a"
    sha256 cellar: :any_skip_relocation, monterey:       "15de3b38857cc7840007d20f79ddf40edd7116430f4f3b78be391ba1d59918e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6e76c6797245cc1fe323a0bede30595ddab6531d7e2ef9e2024acc02c658204"
    sha256 cellar: :any_skip_relocation, catalina:       "0e9a43aaf7927228e78934dad987f53dd478e737562add28c8509cda34c1a1e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b501f1af505b08ef9c35ca70b15ebd0e89f097aeb1abd3b7caadb48068cb6d9"
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
