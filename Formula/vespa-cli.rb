class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.116.26.tar.gz"
  sha256 "7c10fa12d24e8fcf5811b96594d2e1bd6088ce2c3a767e9479ce0d35eddc8483"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04ffac395203b2a2b6a7eafbe3cb3d18168b77711c0e03939c95bbbe1f239c69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2f38901577f5273df2f83b67cce409ef21258e2ed73464f387f30a032b0bbe6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc005b0b53c5a64fb66760de6b2823a4bf0ef63eebc7f9c398a487413f4f7cd9"
    sha256 cellar: :any_skip_relocation, ventura:        "fd3e6adbf23509fdd68d895b4c9320523af43b8dd1621944f377223026619186"
    sha256 cellar: :any_skip_relocation, monterey:       "c2be551da18690edc2012fed459ec96a993c8756b7b08f908a1c8ce0518ba300"
    sha256 cellar: :any_skip_relocation, big_sur:        "8cbc72261076c8fc449c80a4eced4501aad5df599329d497bea3bfd5a601531e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13fc356cbc955034557612bd65960f6b5d0ff9672e63d5536ee778f86651ecc5"
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
