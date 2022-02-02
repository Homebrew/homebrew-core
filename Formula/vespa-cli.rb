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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "122da09cdb6303cbec73685a46ddf35ae0b8dc6e74bffcea0f0ff93b2938de3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5d5a8863a0563ec7d0c8aa0dd0cd7b49828eefa04a06fb765829775c0e7629e"
    sha256 cellar: :any_skip_relocation, monterey:       "dfc009c0d3dc0016339ec398433afb4a1eca7e92992395eee9c9421036c4ad6c"
    sha256 cellar: :any_skip_relocation, big_sur:        "9124b8aeecbe8d7485ec3a029070fdd454edc74d60fb04728c316d5a7d53db71"
    sha256 cellar: :any_skip_relocation, catalina:       "83616f16c9bbac0c6abe3ace4f3194f56dd9d188fe54572f8d986e43ba7085c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ea8c709f601c60f1d535c04fa5e990905c9bbfc79eef9bdc0284badadc637b1"
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
