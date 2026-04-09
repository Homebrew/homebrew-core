class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.667.16.tar.gz"
  sha256 "be191526dbfb160b556fd2b73cbe3d52d7ae664769a5d80755ee7b00ce4af2da"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57220d0b38156f236ccf038a17b64d68e9f4bd521c6139afc09a23117f7c477d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c0567f4b579f5c4e80bc51b5ab003de240a43a01f1c4fbf4093ceeee5462c99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2917122f4c5480f0b15debb4922647a6b80c1570d904dda82aee390f748a942"
    sha256 cellar: :any_skip_relocation, sonoma:        "c10c57720b1f1dcb8959bda29ca992a7343250746b8313938234aede44764d69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34630d46278a14fcda611d7daaaf059f7b1b019cb6251fd0ca1fb2b6fbfae543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ded43c9b27bce913b9e9ba615a6d92e6e3a597819d85930bff03bb0d2f7816b"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", shell_parameter_format: :cobra)
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
