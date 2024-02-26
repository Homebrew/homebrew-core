class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/refs/tags/v4.42.1.tar.gz"
  sha256 "be31e5e828a0251721ea71964596832d4a40cbc21c8a8392a804bc8d1c55dd62"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb0a7ad9744e73e346f14e5e16c22e47138d284ec327a8fc185bc1c97dc8062c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78a3a9e03f8d6813e13791c0e241c177c8159929ee2a77b8dc60eabfa62a2285"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f28757eaf310fb437fa15ccbe5cedf1f436e97dc069b2899d0e1829c9210d20b"
    sha256 cellar: :any_skip_relocation, sonoma:         "7dacf2ebe4b38246aa042aeca071c7f7d88d9fcbf55e2e7176a143f60bb1f9f9"
    sha256 cellar: :any_skip_relocation, ventura:        "91b8dc011cfaf1a9e0ed1e0eefa2eef1e232ef0a0b3b049efb52cef2feb791bd"
    sha256 cellar: :any_skip_relocation, monterey:       "a70e92cb7bb466729e20bf7de0207b00ef42738ed79bb7f4e16413be12523e48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c818bf8b6256fb04aded6ceeffb62e2267fc8835a47e1b1db94b71300524f535"
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
