class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v7.577.27.tar.gz"
  sha256 "9392a6189532d40a1d284bd8c16688d02d0cbf7759ffc82ceae9e278b12d5e5b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0dcc782bd192069e430941945586a15e7fb7567fe7a264c4cc2fe1f007a2ce41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51fa9176768ebb7779feb82e89ba8dac9ec0eeeb94a4fde10dc8b6820cb82cad"
    sha256 cellar: :any_skip_relocation, monterey:       "814753b496e16930bc80c33845389054e17cc129279ad5184b6bda591f17daa3"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea9d30c154a684aa9484f360b0c7b3f78a0b5a37652dbd3d6dd910db0490963a"
    sha256 cellar: :any_skip_relocation, catalina:       "e133030f65650dd4781b5d374915add13c9698783831d2bdf55f23ac20b8540f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e58b38c78ab4397ae353551f4b18a066bef192627df29e0578efb296e1c3a70"
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
