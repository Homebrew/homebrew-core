class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.153.19.tar.gz"
  sha256 "d2f055f877c91b5bd2a168b510acb24e32d282e0ae403a17f26ab97f125b5870"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "878dabcbc70c60f5e5fae41f72f89532760d6e0d9ab756341e64f3b90519e479"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af57d43c39587bf221e325cdda5bf7ed79b21e8d58e2109ca244fa8c20a88c1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4154b737b1ce1cbef0ce4fa4006e77e9d6f1789b098d0f8c064300f37e9fab05"
    sha256 cellar: :any_skip_relocation, ventura:        "f5fbe9a414b58a7c96aa74283baf6aa96b4de306de041811d7b202b16d0ef30b"
    sha256 cellar: :any_skip_relocation, monterey:       "391d69cbbc59822beb1a99decb5b114cea5d3e97bd52ed71061e3ccfce7788d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "140a2b5b5d500e584ca6a59980a444a82a424d7d92273fd29e75647afc313adb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0c61a3083f8ed6a8a2d05c54c5c001a43233daa3da7a3149f24243485eb0f27"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "all", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    assert_match "Error: Request failed", shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
