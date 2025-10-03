class SoftServe < Formula
  desc "Mighty, self-hostable Git server for the command-line"
  homepage "https://github.com/charmbracelet/soft-serve"
  url "https://github.com/charmbracelet/soft-serve/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "9d679296f46840f535aa934c4c03f332507b704d7dbe165b4920e012caf20ef3"
  license "MIT"
  head "https://github.com/charmbracelet/soft-serve.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29a82e5fea3132e8e8372157008e6fbf4f25bb15339110a52102a21b934dfa37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d644e5ddd272a9e8951324a4d27465dc8762eb44e06537ae2b5bc8eea9ce2eb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2fe6013df08f946f18e3acd3cc675f69065e5d33333c19343e807f9e12a139c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5548ba229f68f6102cde4dfb0947403776305ffb6455663e5fdf3241de7bfa00"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c30ebdc67af3d0941502b1eb8470811d8991f0ae90ca748da78bf64197b5865"
    sha256 cellar: :any_skip_relocation, ventura:       "9360c312cac09e4bf97fd8b043a86c41cba44c7669b2dc97e555d21e7abd9865"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1caef12c9b0601292400cb72639377935301747602e1804cedb6ad5dd4dba1d4"
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
