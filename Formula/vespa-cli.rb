class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v7.534.29.tar.gz"
  sha256 "40903560256fa239c1bde4e3334f6044c6a0d01bd7c0bcdf17b4ca41337278b7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "049304abd643d826e21ca2393e4411e89245bc3b1eb0b497ed30445bf50f1012"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd10c4d6aa73bc7340469afa9a0bc9798495bcf925432d3c5486bacc7b71cb80"
    sha256 cellar: :any_skip_relocation, monterey:       "51bd23d9608e8d44674b0f5839397c396b9e812d1e80c1fbbf8649960da5b5da"
    sha256 cellar: :any_skip_relocation, big_sur:        "b25437e12a459f2b7738e4c0882b05f7286a3fff1e28df090c3b0934c652dc8d"
    sha256 cellar: :any_skip_relocation, catalina:       "c529d34128e75d97c09b4181b0cca81cc9f3d4442b641b3faabb1e7e0c69004f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "619233435cd9b2922aa42b255ec6f7a8bc349006421820ddf8e238cc63fded49"
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
