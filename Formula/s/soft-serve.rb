class SoftServe < Formula
  desc "Mighty, self-hostable Git server for the command-line"
  homepage "https://github.com/charmbracelet/soft-serve"
  url "https://github.com/charmbracelet/soft-serve/releases/download/v0.12.2/soft-serve-0.12.2.tar.gz"
  sha256 "b520cafe241855f3c9db34ede235ab8191c7f638e1bc7d34f5fb1b29a17e1345"
  license "MIT"
  head "https://github.com/charmbracelet/soft-serve.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "378319d05069e92b9f3822eec232409203921c5e3161088f87c14d361b165d29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bea0d6f41da8754e84b15e0fbb9f79542ed00bd7dd1a82b1008ef42e8a45b09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e410ea6b4df21cab018bc948de6ed8f66a6833806dd6bca4cc5291880dce14ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "f575e8e100a22b5b71099330220694c05f536fa41f08351f6e604c35fb3cf517"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2501cc13221c19473333335b6240eb641a27253d054331b7d7a1757aeb73bf80"
    sha256 cellar: :any,                 x86_64_linux:  "4af75d12fe3ba8e7bdc3a479c0af0efdf55df140883a7df34feaf9e83982152a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.Version=#{version} -X main.CommitSHA=#{tap.user} -X main.CommitDate=#{time.iso8601}"
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
