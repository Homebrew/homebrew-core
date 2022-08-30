class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.43.64.tar.gz"
  sha256 "b59adbd7703f760e4668a84c859a68dfe4c728ed0859bc84f9a53026a54926ab"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17817f321dd3e49a85a11972bbe842fc484f8e376a12151a936e48f08dd95b7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "393b019d66910bfa016c0ca7ac9cfc97e692628708c0851d73f29e0f38bb91d8"
    sha256 cellar: :any_skip_relocation, monterey:       "be828f97229699407e625366bc1ea1fc57418a64bff29da8de82a9cdddbda9ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5e948466b8d649473a9bd32af08301e4fe29127c2286cebbbc1fbcfc15fd6d0"
    sha256 cellar: :any_skip_relocation, catalina:       "41d5829c367ed001b55693dc6d4585f796d88b7f577a50658f766c21800fad17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c78b1bfdf8665d783d3639ea5acfdbbaca4e4e8202127473a6a0e5dad7bf79f6"
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
