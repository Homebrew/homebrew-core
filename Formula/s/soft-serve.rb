class SoftServe < Formula
  desc "Mighty, self-hostable Git server for the command-line"
  homepage "https://github.com/charmbracelet/soft-serve"
  url "https://github.com/charmbracelet/soft-serve/releases/download/v0.12.3/soft-serve-0.12.3.tar.gz"
  sha256 "87322bb76f691475f2ca1c5787481e738f0eff87f564417019e12333b71591b5"
  license "MIT"
  head "https://github.com/charmbracelet/soft-serve.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cd6ba5b0d65601554d12fb60a2bcf7336223875539f0bc3173de13b54c4a5882"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "faf41f54c5439d3828db70fcfddc21b0955d8f5a3ef465675b9a6e4559154f6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cb54ea4504971f6a6dc7f59a51ccf4bf999f1e697a000553a41ec09b0fa131ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fb37fa67fe12d6dfd52412c1fe6f5be4cfb79cd761eefb35d3881b97e0625602"
    sha256 cellar: :any,                 x86_64_linux:      "dad6677fbfa8ce06563c7cc29757e30cb7163b536211b52bf08f6b31bf27b84b"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.Version=#{version} -X main.CommitSHA=#{tap.user} -X main.CommitDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"soft"), "./cmd/soft"
    generate_completions_from_executable(bin/"soft", shell_parameter_format: :cobra)
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
