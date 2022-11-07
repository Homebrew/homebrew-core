class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.78.45.tar.gz"
  sha256 "56596c790a6afaff5ccb8df5c01ea319838159699d6a9304bf012d4431cdb88d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eaefcbed4a59ad50b8c2ff0a8af10e915d0f072ac6335e80cca15700b545b62d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0b238fe7186499d1d8bc6a8b4f7b13ed4ac3cba936f8683268d713e80877951"
    sha256 cellar: :any_skip_relocation, monterey:       "1a34a163870b6ec8bac193fb427a59166a869ff86c790605862700a8e2ae18eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9a8902ba9577ccd5c39f04f6dd9ad7845211707671f3793446b328ae402d925"
    sha256 cellar: :any_skip_relocation, catalina:       "5c284fdf6443a107458a21a985b899e2c984d8314b3c80cba62ca677deae50fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa42eab7c1f12553cde06f9ef80341e2a0159e8e8400187d6405392dab654fc4"
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
