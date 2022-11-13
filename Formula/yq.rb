class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.30.2.tar.gz"
  sha256 "6dc5001650ee6a3ada4f4464b31da1128f5415c0f0fd8be9aca15e837f7eb90b"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3992eb76f3d59cab69437863c5f57b3dea0ebedcca1aa906297b93ef2ac7a4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e405c1323376b52b0acab0fa9401b3b80290aeccf3e86b4a4cc804687e9e6d5"
    sha256 cellar: :any_skip_relocation, monterey:       "771a1902c4ca496260ef9d25e82a9442ceb68d8a93ef720c1924804f19b81174"
    sha256 cellar: :any_skip_relocation, big_sur:        "afb61d4c5c98552bda9dd979ffd023d95f66e27613226c2fdbc016dddbc43595"
    sha256 cellar: :any_skip_relocation, catalina:       "575e439243e4b4a48420e9d4f08d1b2f6ae111badfb910fa7d89f125f6c50317"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "198d5205e7b25beee46c9cd25876c0d08df4cd695a5babc3b3e0119baaf72165"
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
