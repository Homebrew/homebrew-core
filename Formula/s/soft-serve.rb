class SoftServe < Formula
  desc "Mighty, self-hostable Git server for the command-line"
  homepage "https://github.com/charmbracelet/soft-serve"
  url "https://github.com/charmbracelet/soft-serve/releases/download/v0.12.4/soft-serve-0.12.4.tar.gz"
  sha256 "5c6d2668ac06aeda8c6e8c0eaf19c4ef33557869426a187ec8e9b6e0350ba400"
  license "MIT"
  head "https://github.com/charmbracelet/soft-serve.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1596e4fa46f393a685b33319f7cffe2b0fda6effb43f4f6d2bcb0a65e0bb7037"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2cb708ab9c4149c9e9b9ee91a31b337beb1807725b1fbe0fff8ffada3ac80d5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "879a8193a2f739b7a1d1d84b5660513f8454df7f73960f823f0b53a5c7d9b886"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d3367920e4fd69d1a8da6ef6f518942b69fd1410c240864068b92c189a5c8981"
    sha256 cellar: :any,                 x86_64_linux:      "89a9dae030949afaef854735de030aa34bcf216008f60fe2f655d3fb05e73446"
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
