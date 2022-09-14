class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.51.18.tar.gz"
  sha256 "86e264bfdb89b675739736de63a469119d812b52a5091a892b1cba3d1369ab2c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d262a37d6f2c02467a36842daa8a555a4b01cae9907c1315870690821931a79"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a480309133ec75720d7b2f8e233dca9bce294c5ec2aeafcd9ccf35bc513016f0"
    sha256 cellar: :any_skip_relocation, monterey:       "38e55d71c0d60533a61078120bcbbeb84b916825b7de55deaa996bbe19146a6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b70527e3c8c3f2886453066cad8889fdb603960feb63bcd0db785b21c4eb621"
    sha256 cellar: :any_skip_relocation, catalina:       "f1f4ef84290faba13add6c83af810039464d5c60dc60bc55655dafcd80eab50c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddd62bb2416a407876a282a2e74b51b97ec76a585bb7a9581201f63dae6fc984"
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
    assert_match "vespa version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    assert_match "Error: Request failed", shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
