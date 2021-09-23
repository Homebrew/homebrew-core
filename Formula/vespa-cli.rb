class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/vespa-7.469.18-1.tar.gz"
  version "7.469.18"
  sha256 "d718dc93491ea05304d576d3115f408acb149e568f884a5c01321b13780698a0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3e71d8106e4cdc77a7961b9f5030296304fbbade4a63e788a901485436e322d3"
    sha256 cellar: :any_skip_relocation, big_sur:       "f0575e030b2435b12c96e328701e7b810c519e0a96e2218ca8e52b780d94b236"
    sha256 cellar: :any_skip_relocation, catalina:      "3a9aa9d2bb9b211830fec09da66e7970588c795532d0d4e31c8a0499216ee39b"
    sha256 cellar: :any_skip_relocation, mojave:        "85c68866f2a650013226439d1f4be8a1e9ee0395aa30b9099ca46a7a538f56e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdafe53f223a99c0ebe3f5faaf1d73e0dedff279d1f2a72d107fd7e3028cc86d"
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
    query = "yql=select * from sources * where title contains 'foo';"
    assert_match "Error: Services unavailable", shell_output("#{bin}/vespa query -t local '#{query}' hits=5", 1)
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
