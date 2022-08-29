class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.42.21.tar.gz"
  sha256 "ce4f20e2e8289393cefc278616a14cb52620a0dfe467e218d2db2de3eb714f4e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26cea5297528aea7ac876440d2f25001f00cce373ea6e0f1b072da66c243b1e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55ff117bb5018796a0300893720f367255779ed4141f7345fb3a950ff4800d9b"
    sha256 cellar: :any_skip_relocation, monterey:       "e654cba94e3071bd3baa698c3d02373310f2daeb6e7523c59b727dd6c1abcf18"
    sha256 cellar: :any_skip_relocation, big_sur:        "8df6606e9a6c29fb2c5805b3b90907fc166cd58bad45e437a1c541975554963e"
    sha256 cellar: :any_skip_relocation, catalina:       "11c04b8d592a37c88fb3d2f1484be93e811018ba8b2b7a469998b914bb0eac3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6ac5c5945bec01ea65153950c3c852352c3286fbb215c9e6802b76dce93d934"
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
