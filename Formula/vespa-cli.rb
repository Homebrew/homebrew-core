class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.131.17.tar.gz"
  sha256 "9e4811fc1079e033a279cebf6581c0fb282b0993c29af1664eb70e3c2d807a2b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f590eab79022e04ab7b519c7e828e8f88f27351b38ca6bd7cadc33e45d47516"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f82c590621469b9e0d62483c76accd7eb1bb5ed362d1cc5d9cb394642a19807"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5cc20cf3f8a35dcc0cfcee9131e5e0af721a432d02f7b1cbef44fa8cf073adbe"
    sha256 cellar: :any_skip_relocation, ventura:        "5ab72dcae494845c09f9d1d9406a94498d186e324d1f46d0005798408570c2ac"
    sha256 cellar: :any_skip_relocation, monterey:       "c8f12503adf43f1948916d506b6660be3c36b90917d8f2fccdd6aa2e8585a402"
    sha256 cellar: :any_skip_relocation, big_sur:        "14d12363713d66f1acfab66ac1b26558c2b067553be7f9a5f8514978c6709fbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "feddd41d64be837dcd9b05ce33a6c428e0c460b21136fbd72689a31b1974e662"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "all", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    assert_match "Error: Request failed", shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
