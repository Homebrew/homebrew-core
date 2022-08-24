class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.40.27.tar.gz"
  sha256 "cc28ab0e3c8a24ea105d18daf0c3b41908332f16208f6fe5a1bab11659eb8048"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aff15b375ad54210efb7c0b634362ce10ac79382e602680f82b8db10bc74fd7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c119d6ce08b4ff1007afdc58d1aefa053defbcc45450b58db75d2a5f1aaf995"
    sha256 cellar: :any_skip_relocation, monterey:       "9683aad6d3c595215cbb1dfd686fd4949d3aea82a90c6a9da53f1b7d64bb37f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "6cc33516c3cb8c875ff6c96491c293a0865fa37741ba88c38f3e234dcfac5c75"
    sha256 cellar: :any_skip_relocation, catalina:       "de9ee875c46080a5ad831ab430ca18dce4367c35d7ae8524f0c86620ea78c28e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ee5e3ef88385bcc5f62b6ed12cd5ede92a67e874f2d713d23c0118b4987630a"
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
