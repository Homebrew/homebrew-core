class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.65.41.tar.gz"
  sha256 "fe6b0c7778bc4ac78076ee39e8f3e60878688815410aebde7ca7c06331bbc2e1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a645805db27c7efd1fd88fdfadf59766efb66ad171c43d77cdc29d0ed81ce366"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dae5caec8c2cde3fbed5313f799745a3c9485175830f010862a1d1d1b5927d38"
    sha256 cellar: :any_skip_relocation, monterey:       "75100e9820999a683f87e2d248b04880b5d2b9ad54febd3804a6605a4a098b61"
    sha256 cellar: :any_skip_relocation, big_sur:        "bdd8f1ab133a158c71886ed24209d3368ddd17975cef866e416bdf181b3e53c2"
    sha256 cellar: :any_skip_relocation, catalina:       "d2c6ef047a83c1c02147487dad0b02796da392b8a88e90255199fcf3fc49868b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a19d0481f72102e7d977fe0e114983c926660b8f8edcc58e4708d132dfef9eb4"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s) do
        system "make", "all", "manpages"
      end
      bin.install "bin/vespa"
      man1.install Dir["share/man/man1/vespa*.1"]
      generate_completions_from_executable(bin/"vespa", "completion", base_name: "vespa")
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
