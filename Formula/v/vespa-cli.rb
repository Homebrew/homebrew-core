class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.279.6.tar.gz"
  sha256 "059bdfb857ea643f0e44360d65db8a26c44863c4377c2b590f3204e657b5c679"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5689fa81341ad9bd2a700445f37fa2ea594ed27ebe985d91024a39dc2923b8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93af13c33d644e5a8b8644438309a8a018b2723a8769df537c9b25980058cd43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c57b05f4b75daa92040458249bc81eae5f6748d52dd5e917fb3671bae9aefa44"
    sha256 cellar: :any_skip_relocation, sonoma:         "3182980aa46da702451607666f5f130f21001cb7b911bd2856df9d16662fe2dd"
    sha256 cellar: :any_skip_relocation, ventura:        "c248cb0abc54eb8bd502482fea5c12db09165185c0e67707031ad2eba58847cf"
    sha256 cellar: :any_skip_relocation, monterey:       "44aa45068bafa65fa41c5f34e58c74efbfe0c7061469211a808f280a8a2c51aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41a21e771625b4e0f354efc264cc207e37689b08674c7497ae0d6df5183cfaf7"
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
