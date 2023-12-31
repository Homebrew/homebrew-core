class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/refs/tags/v4.40.5.tar.gz"
  sha256 "6ab08e0332697cf6a95383a38fd70c5162d00c0e28ea4b2311e9646b664aabe3"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aaf56c8924eb56ba7c16076d17bb9e5395cfcca211653ac07fdeee5814507257"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4097ae683018665288115fc3e6f530a54780c3127c28f525cd67d108e7d8afaf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9b11fdfb899d316fa7b59cf47ff8cc192b94fe4f74464fb842b2cf1b5662819"
    sha256 cellar: :any_skip_relocation, sonoma:         "93dad322a1a8e2406bab6296a3b4fb117ed9920c0407547571461b7d5c3652c2"
    sha256 cellar: :any_skip_relocation, ventura:        "f0c05de3db0d7739599902dc7f2178607f5e123a6e0fc90e33af6a000cc931a8"
    sha256 cellar: :any_skip_relocation, monterey:       "c72e07c15a1ea8388812be37400a90bfd3af55f1541b000e68071211f18f9859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5f992d8e25b2c444253d6e84ab255612c8f724bc1c28f6fdc608263afb23baf"
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
