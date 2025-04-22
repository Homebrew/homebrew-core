class SoftServe < Formula
  desc "Mighty, self-hostable Git server for the command-line"
  homepage "https://github.com/charmbracelet/soft-serve"
  url "https://github.com/charmbracelet/soft-serve/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "e8a432e8d1a891d7ca6f8b16fa4455db57b3484b7728fdb1ae9a77d4fa0d7045"
  license "MIT"
  head "https://github.com/charmbracelet/soft-serve.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "559974917d8f906fd451f58a24b16f5d50bb3806785b7bc9f003e628e2e34d59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "299e9067d96c78b4cea98c8b29c5429cee8ed376937523057cc348571e536439"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae92b211b6025dcba653a8752cf2615ba3d92110f8b9363b3d8cb39246cd07aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "21e1fca746da038795826c4b64a0ee3d9696a7e941127665a0b90cf2889c1b23"
    sha256 cellar: :any_skip_relocation, ventura:       "7d7bed45e73c6c2bff333d9b684e75c95460322099314c8319f1916cb22f33fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38dfd97a35a041d749cf6adef5060c6f35b4b9bf876e0c7ea4aefa972c92c966"
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
