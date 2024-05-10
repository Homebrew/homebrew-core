class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.340.17.tar.gz"
  sha256 "c685a46d797c8d24d0b585f58e48b51cea529630e866a59bae7187b4c1ea5240"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a38a733ad6909c67734b2a176ecd634c52d12cb24df3f849d2ef7b1947259570"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0cfa6aa02a0cb5413120770f5889319535fff72443f305dde1c6635b785669e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c339177fb134a1b8f493ad719c2a966f55d24eda570096f3c7981d941e046c9a"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7500fa807a7d04e4b1729054fe52d14c87951724b158b24f1c1f6f1e859539f"
    sha256 cellar: :any_skip_relocation, ventura:        "afae1657a7d111f9e5195c31c463236d8001877c54b6bcdb879de68e225d201e"
    sha256 cellar: :any_skip_relocation, monterey:       "b5411ce6cf971241eb137a0126ce67be2cc6e165b0ffdb58c4453d7d5635d1ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b56977f9ae9a6f1087abd430477cee94929ab74c421368aa236ce1a138a9a4f7"
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
