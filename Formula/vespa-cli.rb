class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.156.36.tar.gz"
  sha256 "a9a769b020f8265592152d21c7c52aec8f974045486902df54e2000f38e744de"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1c8648d74efc411d271896c90aca39c5a4a33390170d7435ef3d13c32117563"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba3b2247e02c45eb351a0b2d6e42d14418b37a32fbc7b762a5ed8153b3cd7f1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81803480d77dad80459695bca05d318d1f8160b061d5944bc3962c50212b1e1b"
    sha256 cellar: :any_skip_relocation, ventura:        "9a315e3a9ff3818d5c36fa3df9def7eaeb6e99282b966f5dbc8cf67b80d395d6"
    sha256 cellar: :any_skip_relocation, monterey:       "7843946160a9d005250e3fb46730cef0d75ac0e2b3c4f3003696a06fe4e470f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ca396d007b3d5832eb19c8a8809234e154c4c7b8d2620ed45d10ffd32688f5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0ee85089b650ff97cb17509307f68d12e900f09528a3b6b64bfc5141fb3e8eb"
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
