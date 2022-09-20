class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.54.61.tar.gz"
  sha256 "5169d06ad5065c12f3968909570baacdfef6e84b28243d1173b7d508284847a2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7072e059439846efa9ef9e97918825a3fea10178fe9d4feebf011d5c96d954a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af236402ba0e2b0eac668abf10196415dad8d8ff9057fe597eda57230343ca52"
    sha256 cellar: :any_skip_relocation, monterey:       "56c3c43686487707b754b3c7151b30d0fe822f34c1100586bb81395bbee7d458"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1d5526dc00d76846acfcda4180742e96a7159fcf40cef5913572f90ca815fa1"
    sha256 cellar: :any_skip_relocation, catalina:       "84ae5660abba170ccee68ba2b79df90a64b21c698b9e7c17e0d66aeea4391b21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7aebf9cd8108dc0a7117dd3a4ab81b42ed8a6c4e130f602d93c0b4efd620c4a"
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
