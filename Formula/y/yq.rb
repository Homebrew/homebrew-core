class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/refs/tags/v4.45.4.tar.gz"
  sha256 "e06b9b219ad885b08cf983a7ce5ff6d946587ab4ffc62de4538655bb50e39111"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e67a801ebd410bb0183ae6bd5ce47963b910da7cb3fc77b0b6b1ff59c67a2d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e67a801ebd410bb0183ae6bd5ce47963b910da7cb3fc77b0b6b1ff59c67a2d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e67a801ebd410bb0183ae6bd5ce47963b910da7cb3fc77b0b6b1ff59c67a2d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "1338d9a2ce0b7c03895ff8df6c96e52d150e609c57e0cbc874f4aadfe118f8f1"
    sha256 cellar: :any_skip_relocation, ventura:       "1338d9a2ce0b7c03895ff8df6c96e52d150e609c57e0cbc874f4aadfe118f8f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c64691dcf2f41bb3f474190c4b360918c90d0d652e2d6721f41b95df4779388"
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
