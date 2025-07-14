class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/refs/tags/v4.46.1.tar.gz"
  sha256 "4388aafca667988044c9517cd981dcbeb072916853c3ebd681c12a5038e7eb12"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55dee24428cdaa6dd73f9f4e8ba737d7134cb4715bf2e5f91a3475fada2156d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55dee24428cdaa6dd73f9f4e8ba737d7134cb4715bf2e5f91a3475fada2156d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55dee24428cdaa6dd73f9f4e8ba737d7134cb4715bf2e5f91a3475fada2156d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "01906864efce134dfa2ae2805c244383166da01f2d492f3ec022b3784490ce08"
    sha256 cellar: :any_skip_relocation, ventura:       "01906864efce134dfa2ae2805c244383166da01f2d492f3ec022b3784490ce08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9dabefc868bff015ff6a657e597334be905d215f3d213c3365899fd62914c26"
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
