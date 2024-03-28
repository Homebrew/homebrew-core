class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.323.45.tar.gz"
  sha256 "916ed921f7d703cfec97a28a85988d8d7e0be5f6c1b7f38a5db818f295fc20e1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be8b2061c160cb4c244febc6658521cc1114303f77152ef2b21a5cba7419edde"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58298efb8bca3464ceb80b1f84ddcbb39edaf25f493c9fd523add59d912e0db7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f5b54a3caf1be8852ade744979d1b961710a35c2c33b075c5fc3eb691dc73ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "b61a10e34142e8fa2fdcbff65c7d843ed992c555a493748f90f8a87a6ba65017"
    sha256 cellar: :any_skip_relocation, ventura:        "777806fbbffe3d74dd8314d40e5e388827e938c6e1a4ef1a326d0839537911a4"
    sha256 cellar: :any_skip_relocation, monterey:       "226a6a9b86ad64b4ab6fd1078d2929c59335f36dfbbf23a9d7eda6d563e2e03a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea8c64a6c83c119ccf06bf7de0a81e898f60f22f1d7adf40b2f07afa8d74f1e3"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
