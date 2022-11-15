class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.30.3.tar.gz"
  sha256 "0f6abbfe46d647fd533677733c17f058c86642fa61ab493d219b0eb3be0f87c1"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a76092e9be0621adcbc75f970dbfb408768f2444b5855b402c69e7e6203c7c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd4b87b1ac8a73c0776c1ca8f7d774b4bb072432ba7ce0bcae419d416c4c25a4"
    sha256 cellar: :any_skip_relocation, monterey:       "03e3dee6098d0c4245ad8cf148a5bc9b3743fff0a3ca26c4dc4d65ea0c44440f"
    sha256 cellar: :any_skip_relocation, big_sur:        "281439e6da2e2bae04cee79e750969a35f4205e0bb467e38f724a1eeaeaa2faa"
    sha256 cellar: :any_skip_relocation, catalina:       "dd3de0572b0a7dba066c1dc13f79843f60092260b4aaf6e7604689176cbae57f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5066deb9faf30a4e66bf931a157dfe04605f3cd4fdc41e5e3ff07caebd02a08"
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
