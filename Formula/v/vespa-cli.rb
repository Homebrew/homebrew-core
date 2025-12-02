class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.614.22.tar.gz"
  sha256 "435fa14fc52188ae0a801b556fb3bc7007b0dc2b6363d834a4e53b5e87b7a9de"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "485cdda6986a4f38a333b9dfa3fdd9a461a6593ed5092b71610dd4e1ddf62ce9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "085a8431334033994a82f5cbcc46759c9b4a7bb12c8bb9641569a02a4101e0a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07b27f446e01d42d113cd156781e1af7844c8b5e551533837c84a5be3d7e859c"
    sha256 cellar: :any_skip_relocation, sonoma:        "fff05744f1ad0c746154ec6f6425f6321a60b438dae17671ee30ccf8d01860ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5322a2a2518464160743f785b8d7ba767ad6c54269d7ea84dfe5d4f830ea2d17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a473182250276c25c24799b78beacbac8405de01cca6ade11d41415a0dbe284e"
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
