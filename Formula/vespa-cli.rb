class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v7.580.54.tar.gz"
  sha256 "5820253d2582761f8e4dcf5df0e1a37f4a3152a33feeca9517676679f9daee3a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5247ade02dc452628a3b038ad4e10037a1639b5e1849ed7af8648f9dc704dbbf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b489c854536e4a7203300c067a80771531ac60067ea09eb1de1f62e8ba7d7c1"
    sha256 cellar: :any_skip_relocation, monterey:       "3613481f701f43bd52afa188a1ac5987aef89569118eb1dc892c1908ccc57c73"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2a00403ef1f212c608b8ccca0fd57f9a9bc8c1ea8afa2d5ef0509732c29dd9b"
    sha256 cellar: :any_skip_relocation, catalina:       "d63ed6d708d6caf847633e337653781a228ac57bbc0ece6a2121e39fd57f3538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f5b2a710b99bb5af017e48b9e4d9c76da263a696317f19a21c1a8fad8ff6f34"
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
