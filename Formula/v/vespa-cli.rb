class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.411.13.tar.gz"
  sha256 "a8939fb8b0f3cee622125a034658861865771c6f3d7440f43b8939aebed4007d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a0ea1349bda86e4186d8413e7b7b841eaec85ba2b694a1bd29d41952e86ff71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "323c1291cc6e279f1560f9a876893d44cb0c292897d37bffefa73f9d2c46fc99"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c39ae573ae223f4741fb2d9032ee1e9dacf562d779825d7b6d5bb63af9e4dda0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9604ad4867ec772c669e76819f6f99922cc7310707102e81a0a82d6546ec9be"
    sha256 cellar: :any_skip_relocation, ventura:       "d202fe81bfe1e0bf3d202fbd978f73ad07ffaac32f518264bdc0ee6fbf90472b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27a8e17837f8c056bd89970cd2ace7d3e108a19346f0ff578e7001bfa9a651ef"
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
    system bin/"vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
