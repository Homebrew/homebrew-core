class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.4.15.tar.gz"
  sha256 "ceb79aacafc1ac22769064ee99ab451a1b37eafe3c6105b8c1e880636dc2ca07"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f99b4c164b7fe1db8cfbd10750374af82f87b94bdd3efc300c42db22bfdd4cf3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7175954290dd59a5b1347452f27d2f1a6a0f07ff7f3e5c80baee48c48470ccb"
    sha256 cellar: :any_skip_relocation, monterey:       "324480a018c89e0ad6390c2286157f7ec428edb87f2824853043cc5bfa940482"
    sha256 cellar: :any_skip_relocation, big_sur:        "b11f0be337485a92ef2bbd7d53f4cf3a3502cc2ad4c6fcca880b800b273f082a"
    sha256 cellar: :any_skip_relocation, catalina:       "e91337d6ac0f3ec4d0ff2e9dbfa0bae79c9da6fb410759fbec641f989cbafa03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4845997ffb92139c6b88d65e3f4563dd92bb527d26f85cafe709c43342114ac"
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
