class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.423.30.tar.gz"
  sha256 "65edb626c202df9ecc12cc0c5a906b45da0f3ba966f7cdcdca6fe898ffc7805a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe94d28ed1fb41960daa85bde76f38f51d79958215353c5ef139aca2d1f15b9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66cdeeb45995ed686f06b707cad8829610987b10722a30c4a51f018a01bfdec1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "400b1ece313a8af8e309cde7bacac263839d6378f15e7ecb6e9de224f34616e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a825730a5a99d3689ea690575063699e0e267264289d755be92a2bbcd09315ed"
    sha256 cellar: :any_skip_relocation, ventura:       "84b8e82709f081aeec9db6dc9408ffb82c05c3cd7479bc67c5c0d38d74ac5932"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddb8672f275bb5599dd1b86c6d649911b4bd41c29a6a0f364c9da93899578899"
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
