class SoftServe < Formula
  desc "Mighty, self-hostable Git server for the command-line"
  homepage "https://github.com/charmbracelet/soft-serve"
  url "https://github.com/charmbracelet/soft-serve/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "c0d9b4e7f1b2cbe3d2abc161b61846ce03743f365d961619fb43b4fa35da11b7"
  license "MIT"
  head "https://github.com/charmbracelet/soft-serve.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "346b950e55031ae029a9e315c6bd95b1087641c68d67bcd0ad19b0b9462c6a29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c183e7b48cd167d9d3a1d9f0888cb463653301a468486ac05b038f1971e5c431"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c067ebbc93a15e69d2d9300d6a377d7ebb4f5fdfebe0d627b14b9cc4f2222ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6c695c34a265c6e360d8a173b9f5db8dc2aaf153129adf7421cb691de75b390"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffd5dc8993ff069d2629b69807cf40e0650755f4a5558dc852535253b1e42a2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7939e9e481165c7f89891ae8e7abd51d20230443daf12064e6c5732b49b19f57"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.CommitSHA=#{tap.user} -X main.CommitDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"soft"), "./cmd/soft"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/soft --version")

    pid = spawn bin/"soft", "serve"
    sleep 1
    Process.kill("TERM", pid)
    assert_path_exists testpath/"data/soft-serve.db"
    assert_path_exists testpath/"data/hooks/update.sample"
  end
end
