class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.240.5.tar.gz"
  sha256 "6ecb97977b0e7e5f5c8fcc5cd5fae4a8c8062280febdb2795210ad758ac0804d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f100217766d7feb7ebf9ae24c09eb59e820ecfa05cbe19d7e641b4005336ac9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd5748cdead27be35910ecec25b42a4085e554f005862609f9a96f8c2aee7bc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6ead2d872b54a93c4f888ed548d57fc883b77e9cf41cd9987f60386a113163a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a58767bcf309821421c7e90aade6a32c9dd017dfaa734c6d7f5ff9ce674309ef"
    sha256 cellar: :any_skip_relocation, ventura:        "ee58768e5cb38e26221f93099592990d7acf11314ad89406bf0db8b836355f4a"
    sha256 cellar: :any_skip_relocation, monterey:       "ce70c0abc31da3a8ee7bfde20e950ffc3d57c47e31a040151fc20633fd755d3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc852912158ef542e9ca1ea0f740a56bd84e0cf261fe5d41cd6fb5b80d2126dc"
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
