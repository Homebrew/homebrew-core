class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.323.45.tar.gz"
  sha256 "916ed921f7d703cfec97a28a85988d8d7e0be5f6c1b7f38a5db818f295fc20e1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ea4cb8968b8769250958e1dd1172356001c1a62b43e010a915790851ea334a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85d68f289a7fbb94f710382eb547b80c440b037445d8b339657f1e72f500b07d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d487edb86db02cfcd16c1782e20052bf6da383c7939a68cee6427441deed779"
    sha256 cellar: :any_skip_relocation, sonoma:         "f5f1eae0b4bd3f505044a84ab89807d0ac1ac4d8d3985c2be41df42f3f2ffda6"
    sha256 cellar: :any_skip_relocation, ventura:        "716a8c3137f1c07cfe90feb886a97c0be09e8d52940c75b1eb26be82ae5878a4"
    sha256 cellar: :any_skip_relocation, monterey:       "ed68a78378b9b94bea891a939468c41f555babcf9de9cd277b6e1012d29aa240"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a6d7f257b074c4fdbc3b0cea248272c2a30b1a3edbe8ae21f179d4984f0ee74"
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
