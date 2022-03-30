class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v7.567.26.tar.gz"
  sha256 "fd84582df533bec693298de8b6dc365dd6fe6f6af0c8978126fca057d882b3ed"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e6082a3ac06c26f2b5807d611331347e5a09e558590e4372fe8f99c487e4fe2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a54197b7e71e3f58c5b1ce0960ec7ce72102cca0475cd240a82f03e8500bd50"
    sha256 cellar: :any_skip_relocation, monterey:       "7e175681e33b57ded37837a7407944a7e8e39045ad779407c3c61f8abf7fd45a"
    sha256 cellar: :any_skip_relocation, big_sur:        "872964ce2ad8fa37f95f1dba07d3fa604fbf60279447a1bd58e92c226b553a98"
    sha256 cellar: :any_skip_relocation, catalina:       "1b49ba18e49b7a600bfd79785bfab3685d8b688e7424adaec6b4f97a48740cdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11498c10447f7440be15c33526cdfb3f86558f641e7f3b92db578b4951d85e06"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s) do
        system "make", "all", "manpages"
      end
      bin.install "bin/vespa"
      man1.install Dir["share/man/man1/vespa*.1"]
      (bash_completion/"vespa").write Utils.safe_popen_read(bin/"vespa", "completion", "bash")
      (fish_completion/"vespa.fish").write Utils.safe_popen_read(bin/"vespa", "completion", "fish")
      (zsh_completion/"_vespa").write Utils.safe_popen_read(bin/"vespa", "completion", "zsh")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "vespa version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    assert_match "Error: Request failed", shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
