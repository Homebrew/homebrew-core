class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.97.26.tar.gz"
  sha256 "1a2ad7f44e9b5008196fe4d818d883790897babd77f823d855312282bc7ff738"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25963eebbf4c1f6f69d6dc58507d042f9c2e97e4ea555c61bbe6e53a238e1329"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f4e0cf6806e328c43aa240244c95916ec0021c04a545b446bb3b7f8eca3492a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "917fd97a558d555efe303dd82447decf4918526f5dd18785eb4bdaee92f7fba6"
    sha256 cellar: :any_skip_relocation, ventura:        "b3e01e63e26a909c015600e0934b9d3c23142403fa2f1656fad037e92132fdf9"
    sha256 cellar: :any_skip_relocation, monterey:       "ff54324063448590b767da51431e5c7a521bd78c1b7e15b4273bd9ac4d4e1103"
    sha256 cellar: :any_skip_relocation, big_sur:        "64021fd7f8987f6a0826643f80218ab3c7fd4bffc007fd3eb84002219ea4e852"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ed8765f9c0d84f21d3fe5f6dd4c431d4172dbb115acf58563fdec477aea1c41"
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
