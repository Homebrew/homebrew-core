class SoftServe < Formula
  desc "Mighty, self-hostable Git server for the command-line"
  homepage "https://github.com/charmbracelet/soft-serve"
  url "https://github.com/charmbracelet/soft-serve/releases/download/v0.11.3/soft-serve-0.11.3.tar.gz"
  sha256 "63e33c159cd633b90e06baf2a4d35d7fb11566c7ca253b6742e4295da5722901"
  license "MIT"
  head "https://github.com/charmbracelet/soft-serve.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b864993474e39f6298fa839e5fb3e64d5803bba0e7b27cc82da51c668a90246b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e57338847eaa1f4c5d19d9bbdb27e1262887e81e35170bd2dacc7a4f0eb5d87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fb24b50ff3c4f71065d66f36e0b3cff60964b21bac9a815b77dae41e04da72b"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb1a94a09ed3887e6e4c972ed53c3e497f37ee5f2cb74aee4da79991c13e9f02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c947845ed920bccf2a75942cf9fd7c9699a1bd4326f9af8523e86694cbc7a38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "305e3a1c776f91c8eb91efcaa8bc08d91b2f1a1943b3338ccd1a9cf0b0277a75"
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
