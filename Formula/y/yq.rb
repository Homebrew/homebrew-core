class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/refs/tags/v4.52.5.tar.gz"
  sha256 "4b1d8f8d903793af62adf74f4810542cbd03515a728d1add0868072ea9aa00b8"
  license "MIT"
  compatibility_version 1
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd12fa1986a2264ae55be6f0c6f1fe87e8e2d0a115feffc2b36e844633135ee0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd12fa1986a2264ae55be6f0c6f1fe87e8e2d0a115feffc2b36e844633135ee0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd12fa1986a2264ae55be6f0c6f1fe87e8e2d0a115feffc2b36e844633135ee0"
    sha256 cellar: :any_skip_relocation, sonoma:        "d95f1954ec38218eb33a0dbf8ede3a981a88148061561bb7c07195eefbc4de83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2647619244eed1ee3ea137665ee7d21e2aad7c4fd31d1a12625b87634a9dd8da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae3363e74da1d7c440bacaf0848eca6993094548c87abc742460e1f03094ab52"
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
