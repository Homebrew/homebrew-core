class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v7.557.46.tar.gz"
  sha256 "21468a5951a3b66db23eb82635dc86eb6502f682c3decc2653ba878f76bea5e3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3480408b55c973d2f973ac338345025ee86077b59706f908a4f7f175032d69dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51d5dc1ecc4da8ff274e04fa1782b07e0efc7b154c1f91f1c587b8a5dfa248ce"
    sha256 cellar: :any_skip_relocation, monterey:       "0562748f74dadf00455671e5bdc681ee29459881dffaa1698356f417693ceee2"
    sha256 cellar: :any_skip_relocation, big_sur:        "aeb15a522752f284263d966326e61cd7b7d1c8a88bf535d3cca8fd2634e22050"
    sha256 cellar: :any_skip_relocation, catalina:       "ac91545737b6f61973f32a26664c2e14883ba4a9f25973fbe5f44822ed782c24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4709c2b8bf54c2915e149dc4bed87bdbadb798cdebe18f3831b9679c823c399d"
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
