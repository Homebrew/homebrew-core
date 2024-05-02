class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.331.34.tar.gz"
  sha256 "ea491a8120829a9c217dbdfbf219cd792cf20ac3c0640494aa8a24521fc895d1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c87d057d7b2bd2a6df8a83e0bff42044c2bff11680535166b69d175aad02eda"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a0dfa80c50a379421652fe3410fe582b4f530720229c4f7cdafb83e75178fce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "181492ff73bc802ebaa87929aefc9894e31a4da3818c3b968b2eba54ef85674e"
    sha256 cellar: :any_skip_relocation, sonoma:         "94c47668cbf93722634b12e63f9600b145b0df0f7f98f90f31a1170ac2b68c5d"
    sha256 cellar: :any_skip_relocation, ventura:        "36d76db6e6a6c95f78748edee53c84786dbd0df14a7abcdaa63183fb5b783c75"
    sha256 cellar: :any_skip_relocation, monterey:       "4b807a33072f26d023af6dc719e6b0e8bfca9293d41cb70623cc97fa324d03d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1060470df239784135e2acddb92172c5779928c263291d11bbe3d945eaeb5022"
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
