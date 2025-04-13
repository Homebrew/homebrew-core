class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/refs/tags/v4.45.1.tar.gz"
  sha256 "074a21a002c32a1db3850064ad1fc420083d037951c8102adecfea6c5fd96427"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f27d4aadc29c30a6293b6cb9921d1efbc6a94f7031ddc49a32838c3c87ff0bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f27d4aadc29c30a6293b6cb9921d1efbc6a94f7031ddc49a32838c3c87ff0bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f27d4aadc29c30a6293b6cb9921d1efbc6a94f7031ddc49a32838c3c87ff0bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "62e0c09cced0c3707ccfee427c6938d17bc37f89d9cf239d34f8814bd574b3db"
    sha256 cellar: :any_skip_relocation, ventura:       "62e0c09cced0c3707ccfee427c6938d17bc37f89d9cf239d34f8814bd574b3db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cfeabdc6ec19899aac26a851c8ddf557784e643b1d574d75ef18d31fdda961f"
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
