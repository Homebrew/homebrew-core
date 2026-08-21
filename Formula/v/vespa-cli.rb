class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.738.17.tar.gz"
  sha256 "6af3d647cfbc5a99aedad026c272332ebe3115eb9c5fd3ee436e885f5d1d0c4c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "309d1b996a44ba4071147f7333ca562c32bbbfd27345e9639390c528211612d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01482b0f13582a798c81d9c2128b17d6922df077249d95c1d9b4d4f107579a5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27cf6f4596917c15cd6ae21083f30bde97b377d58c979dfc3c074e530ab00c54"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5939d8060cf290dd1ecc45db7c1417017c4935e832d194f0955dd70b9ad0e7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28250cc786c315c1b7c28236440a242ae478d650802c2e9b8cf6f1d67b894924"
    sha256 cellar: :any,                 x86_64_linux:  "cb9f9d39ca3744c4830039d507e6621af8d5d77b924505d7761149ac9a80f64f"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", shell_parameter_format: :cobra)
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
