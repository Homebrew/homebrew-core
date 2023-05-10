class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.161.74.tar.gz"
  sha256 "d459cc5df62ab9a10c302a5d9c634a60ca09220e2d22e618fd60525ef1f5596f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54eb0e36e2785c14807a9709cdf70b7da025236b6a39a4d62b1ce1329cb94d7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2aca41287c339cfa412ace41ed3e88a8c6858682e2172fd1cc1cf0d3c34c2c21"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "700a40ff3b8ba0d54e382036380241eab11e08bca6376b5578bbce3aee80920e"
    sha256 cellar: :any_skip_relocation, ventura:        "4da1eb4f1514cc56f5ef0a26f417f0e6cd4c8c965f10a8a229a783706762f339"
    sha256 cellar: :any_skip_relocation, monterey:       "d84eeb8bf0890d2eb78fd879f46326839fad981b836aedd52d8de874312e916c"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e993e8b407421c8314c911d6380102e5a00a2b2456544948efa22c4ac6b8520"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba3ca8137f296c9da813b263560be95a718f3e0a7341796e0c11b944f8d89356"
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
