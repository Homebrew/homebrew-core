class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.31.1.tar.gz"
  sha256 "6481cd93fe9a773ea20f738a3340c88e691f3d073bc6d2fceee3f5b3867399fc"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f4ffc67cfd0a5a70070de90ee7a55dd6a6abd25a1e0841965a7694e4c96ff1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56dd66a8acda1fa6966795b4e925d930978fff7e53eac8a08f81ae5d325b8450"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32718fd6fcd1adb3714c164314803d53931ca65bee2566f866f5ea1958a94764"
    sha256 cellar: :any_skip_relocation, ventura:        "6560244a87b0b1aee9462203ffbd0525ea6347749889fc9064888e5999cc9e06"
    sha256 cellar: :any_skip_relocation, monterey:       "d520a02091af982a34c1037be317e2bacfe9fa762e16b9658a38d8e216e690d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2014a9841538902736d198590cd67ee0143085ee8b5635cf4a1fc1e045f2f54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e281bc505eea64ffcef5f8e0ff66a43189cb8722ad3488a1ee139aecd1f261f"
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
