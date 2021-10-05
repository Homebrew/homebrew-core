class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v7.475.17.tar.gz"
  sha256 "cb03a77cbbdbbbaa142a4a3fae7ef9d5e0508515a4537fdb4281e589145df335"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "54d226fa0f9d7100472c9859abaa435b02beb4cc9058a6c46f91ccdb9e2aaf13"
    sha256 cellar: :any_skip_relocation, big_sur:       "e723fbe59f093a30f901653e9b3d21b266233a8a9450f25777409d47c0ddd686"
    sha256 cellar: :any_skip_relocation, catalina:      "74de4d899740f27ebab35b58bba6b30245a1db2b766b49cfb301b4b81424abfa"
    sha256 cellar: :any_skip_relocation, mojave:        "6fb1797b5690b8d2228e0d4868804bb2785c739895971b4e2c67465f7ab2a78d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfc8cabf7105d7e9f98a730894439e07c5abaa7d790eff2bd3b674642f564576"
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
