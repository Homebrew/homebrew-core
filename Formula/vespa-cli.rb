class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.136.37.tar.gz"
  sha256 "c1457ae31cf349e48b064324593a4303ae181071046074d180bf9947a82258d7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d08b6358b8df9005f80f16cf70fcd98fa2513d3aa80001f26ab83e14c3cd526c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fac2f29d6e49dd24f60138c5acb063e7f9158bf1f11646f60cd8c57eec15567"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1326328bfb8e7c20e59164aef8bc5a8e8fa5927836e2b8e6e71199b6b455022a"
    sha256 cellar: :any_skip_relocation, ventura:        "5fc0a2afde341c8c415ad090cc87d8d4a7abf43b60d729aca904b8b6e37bc1a2"
    sha256 cellar: :any_skip_relocation, monterey:       "00d5822ca0ded696880e7d267e86cfd48fa040ca5da59006640f2c4d3829b8f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "95109d547c0fc01fb16742bae0e52c17de4687e062e3059428233350ec1eb9b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9fb19150f6d86ca6e571ac9efcd9042b5a2d7ddc444e4b3c8e38fb0300aab67"
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
