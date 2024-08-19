class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.391.23.tar.gz"
  sha256 "96720e9a83997515429a7d7983b1d8f61b8a2ea3845a0c3386c0e3924cba07a6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3a5ba4861dc604e0547b35ffb901708843b70826afad1f64df1c3ef59c26be5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aac4380a73dabbb44c6519cc1eee07f21bd16f53575d677d682e5650f80b636f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0395fd53c2c7a337fdb9c8c3b21262164840a8564eab25d1881b37e7c908bc48"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7128333ff720a2c65a116fb7defbe2d0b61a6eccd51a265bfccc3854d60022e"
    sha256 cellar: :any_skip_relocation, ventura:        "fb1bde94460c4c300a86e43e3c021313c8b2c03340a074fc27f5406c534b6d8d"
    sha256 cellar: :any_skip_relocation, monterey:       "ecf44cf7927dd12dfc6dc6d1df85b031bdf943d4992abe9bea0b8723c4438549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94d2ce3cd218ad4fa2d7572ab4259d27788b30f9cda8b85f323cf51eb3eedb5b"
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
    system bin/"vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
