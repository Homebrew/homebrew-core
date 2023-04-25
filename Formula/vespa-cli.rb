class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.155.19.tar.gz"
  sha256 "a6b5f71a2390dca5f781452409eb2989cda5c6db01a8483e89c98d7af1c95012"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8b4829bbe0bc5dcefb7df8e7e384dd88abce10f61826a0e701ce37bfba85b83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0a47db47bea08137f6a4644ae5bd96d50b630a728afcf8679c38ee3726f10a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97cbf09853355aef179c86bc79ba54485627551b2de4dc49e7d48363de1e46cf"
    sha256 cellar: :any_skip_relocation, ventura:        "94a796b11c68548d950008073eb12660387eaeed569cf7230cfc62fb71748a46"
    sha256 cellar: :any_skip_relocation, monterey:       "8b913109b8555647ab0d52b7733bc37d04c26dde2286d365763fa3d372531c69"
    sha256 cellar: :any_skip_relocation, big_sur:        "f363cc73e1fad46aebd162d961559b6d4204ec019e0017ce6ff80426c90fcaa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54fcdea3d9b18c82638fd0489d057de830276ba6d4eabd79e9d5ae9017307874"
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
