class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.85.9.tar.gz"
  sha256 "e95c13033bf64d494c6d4a2ebb33a44cadde17b07ccbd7e949f90ac1fd6f7509"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71a9065b7e7f761fee11382e29f54eae298b5323b95374dcfe895eedbce0bab1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9b8c8fe1aadb2d260f84cd2827749ef34ec4115f166849dac7a3497a987f0a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f67f5d6a871342a5b034338d734b988ea0fcea31801ea16d6bfa2a960edee4f1"
    sha256 cellar: :any_skip_relocation, monterey:       "68e9789512e87a800e2439fb292af826ad94f28a4eccaebae494e69931994304"
    sha256 cellar: :any_skip_relocation, big_sur:        "e96f8c3952f9cad3ba4d84df96f65c4f282f8e4e1877c4132e1cf47f7f996500"
    sha256 cellar: :any_skip_relocation, catalina:       "3884510bb6288763415aa9e12482841f2759d59279268e3b2c1b7a49e8a01474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73dc9fb13fdfbebf815330c2dc093d2cf8511241df4c037a26c2865780aa04d4"
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
