class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/refs/tags/v4.45.2.tar.gz"
  sha256 "7ae8f8a4acc78dba5ab3a4bb004d390bbf6fe1cd1fc5746ff7db19f8e627b84f"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00ae48fd0ccb3757314dbb15c2a4ec7179f8b3746bddf6fd915eadc734f3a380"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00ae48fd0ccb3757314dbb15c2a4ec7179f8b3746bddf6fd915eadc734f3a380"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00ae48fd0ccb3757314dbb15c2a4ec7179f8b3746bddf6fd915eadc734f3a380"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf60e9476c96ed855b2c96d020723526ef552c2fce449bb4e9b22b260a59f451"
    sha256 cellar: :any_skip_relocation, ventura:       "bf60e9476c96ed855b2c96d020723526ef552c2fce449bb4e9b22b260a59f451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a999339a362347193d445f836c3dfb5b2bc6cd9f058d3c72fb8c7f525420064b"
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
