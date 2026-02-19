class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/refs/tags/v4.52.4.tar.gz"
  sha256 "8735165d0dc9a3348283dbcfd5916474ef30281f855909accc40395a5f851dea"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c71c386ef7e7b1a61b691bee0564eca62a3875382f68812d88589868a7a9d2a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c71c386ef7e7b1a61b691bee0564eca62a3875382f68812d88589868a7a9d2a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c71c386ef7e7b1a61b691bee0564eca62a3875382f68812d88589868a7a9d2a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "15a904f2344b15ba259b7a950cba0bbf67556dce8775b7b1fdca2086bf6d50d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea53c4402fc41c96a69382ef3b92a08ff3d14d86acccedfd5a177f59e9e28089"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6a22295f8066c7b105203952b3cb5fdd190e22fa7b718ea6a15093b112de2b0"
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
