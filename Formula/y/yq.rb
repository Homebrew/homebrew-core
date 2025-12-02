class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/refs/tags/v4.49.2.tar.gz"
  sha256 "648d96cc490a4e08edb6bf8ff9498360b405263e202663cd9c92322b3aa557ef"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1bd2d5b588df0996f20ba6bc2d3c86b6c6927b1cd60d59759cff9cc98e424b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1bd2d5b588df0996f20ba6bc2d3c86b6c6927b1cd60d59759cff9cc98e424b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1bd2d5b588df0996f20ba6bc2d3c86b6c6927b1cd60d59759cff9cc98e424b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6d329c7931847cd15a4ea4ddd3a59093f92281cd81a7428656676400e5854d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccb67eeed31efde258a4abd516d689292a2e2e93edcc42a0478ebda3655c8e25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c54c5a693474497a3bcb84594ba0339d3eb8a5dad0aa9b4906d216b89d36949"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
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
    assert_equal "cat", pipe_output("#{bin}/yq eval .key -", "key: cat", 0).chomp
  end
end
