class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v7.573.29.tar.gz"
  sha256 "2b5e4f8159ae66455bd05d39d375699f46ab9023d81b71abc1841c12e20b65c9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc17e100d95744c552f485538f6506ef6e543b4fa9dc4ffaec727a9aa6dd0d6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c01044d1ab794f4a232aef9f28fc11583ca901050d981c1afb44d79da9a048b"
    sha256 cellar: :any_skip_relocation, monterey:       "c5ee2ddb3e568b6d71319d76bf27ec953a88cefcde122d73114442da4c3a01bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff61811b18cdf32b8db7479d0a436b06fc401a46171183e9ad22f35613175a6d"
    sha256 cellar: :any_skip_relocation, catalina:       "2fbb5dc7e6743ad870839d6c852c38fff5629c86169eef3655256af4f63672b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f87ee7d0d2058e01579a14fa1c1c0f46e36ce98b45a2b9d5d906902b16530e8c"
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
