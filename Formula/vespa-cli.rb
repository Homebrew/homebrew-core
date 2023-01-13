class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.108.22.tar.gz"
  sha256 "3ec1458de8f42059f4a281555c1d78537ad23a2bf7fcb418a41b9e498d80a3cb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9239e89df5221bb0a1d45f5eea8e73c669dcfc8f3d863a9e1aff22ae86c9a3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "519e45a3ca23969cda4ad7b28cb5754c657bba7e06f0da2a62f19a0491105663"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9baa99a56060b23b14f92767242e0e95a68b3e9deb58aa6685ec8f14159c0519"
    sha256 cellar: :any_skip_relocation, ventura:        "19e4f60f19728ea4f54623fa0f785ff4ac2044472aec007e69ab03d3a6b6c938"
    sha256 cellar: :any_skip_relocation, monterey:       "6958c9bebb83675a60e0d77881b30acf68035a0447558554207878b19670de0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2ac1aed3844da0b858c4d7098f1c9be054bd0d736a931aee654165cabe82ae7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "130b61782013c50cf51b224a85b46cdff7253e03542bb099c35a94716158f44a"
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
