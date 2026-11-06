class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/refs/tags/v4.54.2.tar.gz"
  sha256 "13391403bb284452e102a532037c1ce5f5cd9d2a45f3e70521e810d5c32afe46"
  license "MIT"
  compatibility_version 1
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "69b698c900cb0458e22e9b2261f67fb665b448b131f788f7611f1773431ad95b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "69b698c900cb0458e22e9b2261f67fb665b448b131f788f7611f1773431ad95b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "69b698c900cb0458e22e9b2261f67fb665b448b131f788f7611f1773431ad95b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "271d4524ae546930ae4540094f5e1a8807e33f0e531018c542f97594b78489cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "edf7c42fc120d260de08df774b9372461c2b4bdeef9f062b9a00b3b94e49e268"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args

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
