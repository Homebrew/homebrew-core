class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v7.565.113.tar.gz"
  sha256 "cd1e03ea52254f17bafef0cadd9b248a4714e847cb51451768a31d969d5051be"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f931ed327aca20422316f6d3fa2052e5dac1733b5f4c5ddd775acb56bbb8496e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5edceab4afea5fcfa966863615be663a00b3140513db579cea6c95407b949f4"
    sha256 cellar: :any_skip_relocation, monterey:       "aa0d59eedc406de175b8931fa363d0fdb4b33a7a76a36da416a4ba1f0ea1b632"
    sha256 cellar: :any_skip_relocation, big_sur:        "d30d5c3211714421c4d833663fcc3a97f936aa66e8c1cfc1d4affda3c8de66da"
    sha256 cellar: :any_skip_relocation, catalina:       "be090dea3214183180f3e7bf69b66b87052d94eed29cb2235d411f850b255b7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcd9cff3ea08dcf4e9a76f82ac136967b5e4912a22ef786f5af7b0adb08a44e5"
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
