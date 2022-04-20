class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v7.574.71.tar.gz"
  sha256 "786043572f3f520e34102b6beb392a5d1b6116598f7bba721bf10ca14b013661"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d71feb5a7fc8c0b3fa3614d40bc16345974e7aa14140b09456af3f9d3cd39b37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52315c87d9fe89bf150ae624633d4ac97ccca50638a07a93f572a7caa670a425"
    sha256 cellar: :any_skip_relocation, monterey:       "f26ee300063d3a1a033932ae4e5508358cd197676b7a58b05662f26ddc73484d"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d9ddf302682e22244db41db28455f8bcd606d67284dae23d4070f1e03aeff32"
    sha256 cellar: :any_skip_relocation, catalina:       "4c93136c260f8993b2f2d7fedf42bf61fc9a67f185a0783d60d15603f2c69124"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "002602c4ab53dc2993f39063c957d975bc07c1de5e7a975bbb26b372791567d9"
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
