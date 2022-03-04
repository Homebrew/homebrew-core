class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v7.553.2.tar.gz"
  sha256 "03188fee9cfc8653c4ff2963fb58a05362befadc51ea1bf10c12ffa73e03e27f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c76261be8adf7880de6d7fd420604ee2009a4cf3f6bf9e5fd80c422f515b9295"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d73481fb28ee46a20ba00086912405ad0625ff62b42a3ebdf23469976e567064"
    sha256 cellar: :any_skip_relocation, monterey:       "fc6a609d7af8eb865e1b43cbb851fa168a8ec4eca5f7ce70857e9935ce135036"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9832fd565f71873937ae53bad9be51b075a97f4ceec7c0e061938ad5d54ac1f"
    sha256 cellar: :any_skip_relocation, catalina:       "f5aa46dca2e7dc764b6e730cd3635be9a6cbb8d9c959bf79f2b70e6dfaa38e49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f31c8bf2da5bb55c3bcee9b96cc7a7c9ff84d5235b990551568bbb169398a3e9"
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
