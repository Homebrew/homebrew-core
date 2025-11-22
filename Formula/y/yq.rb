class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/refs/tags/v4.49.1.tar.gz"
  sha256 "8823812fc38dd6c4099d3f60f6e58b54cca77bd3facc390f7f614bf95bdff233"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aad7c700f12160ee27f9eafc95250d3304592fa182268a7ba24913be0d943b30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aad7c700f12160ee27f9eafc95250d3304592fa182268a7ba24913be0d943b30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aad7c700f12160ee27f9eafc95250d3304592fa182268a7ba24913be0d943b30"
    sha256 cellar: :any_skip_relocation, sonoma:        "4830b311a270d36a1f537bb174b940ff1544edd3927a8d37c4a7dcf81944740f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6564aa7f1d1ec0f3b708a0fba278ad0bd89daf3f7aec912a90d9f0644c99b6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "803fc8be18cddae095071b7f409c564f463a6c14f55960585d5acf515bc01c46"
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
