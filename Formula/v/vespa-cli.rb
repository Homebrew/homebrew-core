class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.542.42.tar.gz"
  sha256 "ba12985fd95fa7329f8dcdf609b43d9022357c11d7dcded50166e5c25123a540"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30c4bfc014f8e3e0c46204cdb351b2a012917d21e5475f7b60b18374d31facc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "837eba130450931582042d546c2a5beee370c37d07bc6b3106494735605114a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4296399e309db2f9cc529f442e584f448bd97a51ab4832533e0eac7a57a130be"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d58a40de99d334f0f8fd527c44e41120d1ff25fbe66bb6639c788020386697e"
    sha256 cellar: :any_skip_relocation, ventura:       "2998a027dfe853aba83e62c2117e7fa45de8bca45b2b9b030e0da35caff80db1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22ad5e37760094f3f18ac67648277fa99f56551c35c1ad8256bd883b09a3c4a6"
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
