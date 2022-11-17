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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9b6cfac4f129fd2c4bafc85d3d05063977c95df243e7cc5038324515e64e139"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99c9d7ae4b454cc3913b2bd91a479cc6ac22105b239bbc5091aad20e0e5fd99a"
    sha256 cellar: :any_skip_relocation, monterey:       "45e0c71d54a9c81538cf493633bc2c22192e29f6489b243b7f3302f1918ef613"
    sha256 cellar: :any_skip_relocation, big_sur:        "42b30b770b9786894ec98fce54a73f6bb867f83f23cf858d1ae88b91e602d2f4"
    sha256 cellar: :any_skip_relocation, catalina:       "eb912e7e92e94caa26ae176fa63f218ff7290ab5e8652a59cfc8ff64293791bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b65b6d3e045380381e878cea791262d04d9dd5f9ce3ac352800b60fe2b6dfd8a"
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
