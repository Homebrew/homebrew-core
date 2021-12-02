class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v7.508.20.tar.gz"
  sha256 "0e84643e4e7cd83f12e29b2b7f20a50b5c019e140c44bd2a1538aaa7dfedc375"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff52d148b93f6130d08d7c764bbae7d66c0a4bcb2c08f5975b1fafa062cc633e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a5ac85f70a7aa4a09377be7bfd0d29225678bb4d8ac745fb0f203e0132da72e"
    sha256 cellar: :any_skip_relocation, monterey:       "35a7c7ffc2314be5fe2522d7f06b45903bb3dd7b354b1db09c4b3fad534e5272"
    sha256 cellar: :any_skip_relocation, big_sur:        "c20fed9410e4d4c24ed1b5ac481e6fea034880f95acffe5af002684873f38451"
    sha256 cellar: :any_skip_relocation, catalina:       "8809b9cb79b9c918203ad910003b4505e58fad36dd22b80273c8fa0ada7bc16b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b20dda79a4fa541d7ffa8d4e9e12e8b930ee8a961fa0cc807ca49f72647c1f8f"
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
