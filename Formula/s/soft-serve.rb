class SoftServe < Formula
  desc "Mighty, self-hostable Git server for the command-line"
  homepage "https://github.com/charmbracelet/soft-serve"
  url "https://github.com/charmbracelet/soft-serve/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "7ee68a779bda1e0020aa2f44703a4d7e5afdcc685d8af6ecbbb9c826fd03e217"
  license "MIT"
  head "https://github.com/charmbracelet/soft-serve.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3712c7ef413b0aa315161d758f10c0e356508f5c9fbf142d2e413e32a5ebfe71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e8b22fcf3b39827ee0d831658f7a692dc3725485db9c5ab66918d4828e1f108"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b2ede9ba15da3fc6c3ccca807c7a28f08d509a3be572f99ef37888b30c734128"
    sha256 cellar: :any_skip_relocation, sonoma:        "4479c1c3af6fbf2af80c61bdd4bf58e76e2a763e76da853126ef835404254de1"
    sha256 cellar: :any_skip_relocation, ventura:       "06db38b39fd3a598ee680e07d43705eb4a2a73e342607dc95dae3053443c0f77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b30779da797af8a4456e7c8bb67bc31cca20d1cb0120ca8e70d3df1b891c81cd"
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
