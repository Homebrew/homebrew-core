class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.130.48.tar.gz"
  sha256 "8bb2affd5f7a80793382a920da83dec8041eeb8fb48937f1510d75fa6099f906"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2dc6197f4650e97ccee5788e70e7929a8a48e92bb2fbebceea85bd24b6becfa1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f856ced11f6c73baea445003e39a9b8e76c61e3a8e354574cb77c5434cfcdea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea574159909764fb089e778ba76a6c338342ce86119448ee97bafdd54a9be257"
    sha256 cellar: :any_skip_relocation, ventura:        "9c61004892f9b1b3936b798817f368d5a8436230f4c37cbccdb2e60cad661f94"
    sha256 cellar: :any_skip_relocation, monterey:       "4f6ef9c5c430bde14b83715f890f33fc77b078a0aacfd0c89d9c530104992855"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b77596af28ea339b1fffc1f2cd5702dea75055361a003e8c053bd1779e5a2f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2323f1c5319bb69e95d8150d338d527a9a29be7826a908c413ab693ba0a3b242"
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
