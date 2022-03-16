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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bf9e7945a31f8eb2a317f0dfb6ee13d01253f1ad83a39f24a75e145c522ff97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b489e03ffb2ba9fb7d61059d02a0fdfd085ac2f999eb071faeb378cda958043"
    sha256 cellar: :any_skip_relocation, monterey:       "00a4ac03eafa27c07c712c6e1b610a8377897eee9f20357683786f052c28d971"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee70a12bb4bfd21c0e2113deebaed09faa8f5f0994738b2622256e32f9a220f4"
    sha256 cellar: :any_skip_relocation, catalina:       "5df07a7aff094179c8bcc6cf031ea6094784b6a9ff352aab2040ae1a31c5c9e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "142b2c3092aa1a43d1c0311e88006f92b86186ab4897ccaca6630d2c99f84b09"
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
