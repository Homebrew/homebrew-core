class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/v2.5.2.tar.gz"
  sha256 "3f99323effbbc0d8f1d5181ac4cc1c5bd31b50a1eb792866269ec44acf308f1d"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30321c80988c53331b4304fabf72ae68837f1a30eb1efa79de6cfc14151cc56f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e980c41f0659ac603ca06f3c0009cadafadc7ba12c19d372351ee10c23275e88"
    sha256 cellar: :any_skip_relocation, monterey:       "6f46d021e2e169d6ce183806e89d034ff10b0abd96703681e02a12a69014111e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8886aa56ab175b67300b8f6fc4b9436727acb487b7d19c5cd08ed1d96b7bcb21"
    sha256 cellar: :any_skip_relocation, catalina:       "cd37f7fe6ea0390a90f056dd3ac2ac00ba707b1ac2f8d8b5f500cc37c305b1d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6cf4d88636446ccf5c3dffe9d800388b57f0e3cc59594c34515e525ba47f89f"
  end

  depends_on "go" => :build

  def install
    cd "v2" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/subfinder"
    end
  end

  test do
    assert_match "docs.brew.sh", shell_output("#{bin}/subfinder -d brew.sh")
    assert_predicate testpath/".config/subfinder/config.yaml", :exist?
  end
end
