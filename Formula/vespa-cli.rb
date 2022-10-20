class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.65.41.tar.gz"
  sha256 "fe6b0c7778bc4ac78076ee39e8f3e60878688815410aebde7ca7c06331bbc2e1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d7eeddca80931f3084d9bdd207d971b114c3fb68d1d37f270f492ab7297d682"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a0613034ff1b637aee615143f1155630bc412e55155a1fd9820a215ee6d1064"
    sha256 cellar: :any_skip_relocation, monterey:       "9fb2fa994623e836c0cd6d1ea38cd499ac1aa3cb085295d0f7e36870f0a8b791"
    sha256 cellar: :any_skip_relocation, big_sur:        "40293479ee18b2ac6094dd952fc48ba4abf204e5631932fec2dfa8eda7984401"
    sha256 cellar: :any_skip_relocation, catalina:       "f3940aab51ddec04a2cd89adfd53c717aca45895ed3a539e9017f87f49b10d62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e63779a0ca1136460a111bdf32a07fbb03d80cad9814d6e0651ddc0ba93ac79f"
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
