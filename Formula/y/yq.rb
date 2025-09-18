class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/refs/tags/v4.47.2.tar.gz"
  sha256 "b1ed327337be9e044d8222c41f1437313b148ca73ec83946b1ff26e4ff785964"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d56545a2e89ca64ff477691be19098f246b7f8b733c8b332a28a5562cf701b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d56545a2e89ca64ff477691be19098f246b7f8b733c8b332a28a5562cf701b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d56545a2e89ca64ff477691be19098f246b7f8b733c8b332a28a5562cf701b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d56545a2e89ca64ff477691be19098f246b7f8b733c8b332a28a5562cf701b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c26fa72ff3bc32190c499cd753c95973a8409a28a3f10b11f32346980072a2a"
    sha256 cellar: :any_skip_relocation, ventura:       "4c26fa72ff3bc32190c499cd753c95973a8409a28a3f10b11f32346980072a2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac3695a93a6bf57b3aa093c73947497583aae5f48ddbb4d51bddbea73201ca9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e808fd97c9a3d1c6b3e4feb99c43d1ab967751d56ab102a89aa8f0da3d9cfc3e"
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
