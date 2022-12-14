class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.98.34.tar.gz"
  sha256 "d945c4dae1bcb4e0cd576123757bf870d2f5f458e80e213c98fbccdda000bb01"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9d00842eb17607caf53689a4b0b356a09c49db6782020ab8597b485cee15bcc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c79a9a4364d3d384d65dc979ee3bf7557c8dc90221c9c5c7685fd266b55da6ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b365cfdf3cf89d651e366883d5ee397696041aa777df7cec15db0f1c9bcbcd3"
    sha256 cellar: :any_skip_relocation, ventura:        "72d1d6c1332340876054b0a7783c200775f70bebe35e654639e5e890093bd223"
    sha256 cellar: :any_skip_relocation, monterey:       "a57ff580a7dd353f9aed4e1c339d9bff3369fabc1e7296fea3a79b249136ef2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b15a5b5a13581afd9f90563cef9a6be553116b493821db2713d5769527eadaf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97791efd780273ec5f35bbe74e78a459276780c5e723d0d47fafbde88ae8896b"
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
