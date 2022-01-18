class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v7.528.38.tar.gz"
  sha256 "f74a389711c4203e64a2cd6849c4a36bccd75f625021428d14a6af9364f6b729"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb5788c64796ef927132f5350d40d8269f793a19ce78379429e31c4d9d947afa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1965bb7d5384f5a48c9cd9d4a6198847a49a32bfe18433813da1d6cca4e6d08"
    sha256 cellar: :any_skip_relocation, monterey:       "cb1e46c9b6f5a5a7fce386e8c6e014e75ec34294da84f0a1a65d565580033e5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "86821f4bef756dae0903ad494d1514a8f01b40bd4b82d40ccc8d33f602afdd95"
    sha256 cellar: :any_skip_relocation, catalina:       "130a4a184e307ebd90084eb5a9db1cf88a51b30091b87ba1cb8fa65667de4cf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec5457cdb20f5f8b4014a1e6fe600fa15e014882b79b7625922261d068e633c5"
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
