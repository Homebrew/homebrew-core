class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.32.1.tar.gz"
  sha256 "724cddee2b475ffebeb4f11031b6a01267e22350277c3bb965bb1b404488c635"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0f90b8141b90347e22fad656d567a636cbd90b739e798ddebf8a89aa67d10a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0f90b8141b90347e22fad656d567a636cbd90b739e798ddebf8a89aa67d10a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0f90b8141b90347e22fad656d567a636cbd90b739e798ddebf8a89aa67d10a3"
    sha256 cellar: :any_skip_relocation, ventura:        "387224c793ed2d18773f763482f3098ac0e27dcc8d392764c86fa2b1daac572c"
    sha256 cellar: :any_skip_relocation, monterey:       "387224c793ed2d18773f763482f3098ac0e27dcc8d392764c86fa2b1daac572c"
    sha256 cellar: :any_skip_relocation, big_sur:        "387224c793ed2d18773f763482f3098ac0e27dcc8d392764c86fa2b1daac572c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "451d55a153d217734aa6bb12ecbcffd79a1eac90f811051cc74a07bc7029d062"
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
