class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.56.20.tar.gz"
  sha256 "ca286ed407f10107a10948b33739d463a28c32e8a32e744ba0a7d05c91bbdd29"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a75859ae43aa32892a14c90e2c59128f8e703bcf004da7250bfe0d773c01dd8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0861f476384c9592b0f016f02bcbd5246b6fc6caa104a9a5153ab582a5040a2"
    sha256 cellar: :any_skip_relocation, monterey:       "9b8a2616baeabb5eac93f4315e0cc562ed63dde22a3574a3854b5a5272b44482"
    sha256 cellar: :any_skip_relocation, big_sur:        "aeeb575015a62be56761d3ddc380b0ad6c6ac327e4503820ef4fd95b173b4f02"
    sha256 cellar: :any_skip_relocation, catalina:       "d9b592419600acc1fce68c2476206138bc1a1bb4ff7176aa1be69cb987c069dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ff665e34405965530846595db0c0f1b8d5276fe1b1565b6798a28f541111072"
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
