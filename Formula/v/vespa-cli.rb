class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.750.13.tar.gz"
  sha256 "ca7d5affe9e72af81dc79c2086ca6f869c69a5f47dce78bf98941954784ad9aa"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4506e6c98b24d840369eb6bdb5cb5ff3ec5cb182931de8ade67c1da40dedd073"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1479fdaa4ae0aa605562aaa0bede7dfd517455a79931f4ce75348e09c35481e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b122fc10dcf7b931c5f52a6f8e6c23289403f17b77c8d05e70892b5d26607de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "430f5a1d43d0f07603fa17eda3091d18989b491be9c37572bdea7dd42de64384"
    sha256 cellar: :any,                 x86_64_linux:  "f40a9c78f1f45908b884e9e705f44f000e31d176ba3f132b3d470f41ab064985"
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
