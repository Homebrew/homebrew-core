class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.94.46.tar.gz"
  sha256 "dadb556238c100819884c8737696c66c74dfd2efbdb306af79aed8a56a19c1d6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a0c2ca25a5b0b92dbaef4bbdd59246416d8aeb94d55c0d7b36b2e9a6246a7de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b5ebabeca81e4d283f39f4a26eda53296954cec23eb513ac2d57430cb3fa4da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47b49116e0c2c4df4b4f16632edbe8d99d9314de3c6042b6303f1d2b593e047d"
    sha256 cellar: :any_skip_relocation, ventura:        "728584fe405b357cb690fdc6e5d0189a43282a096e8acddc1933f6cc09d61eb9"
    sha256 cellar: :any_skip_relocation, monterey:       "860183c2860a890dd2143fcc03d0db52cf4dc81ec8e54dbab0f4a388a37c5b3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "03ea56d1edafce9354ecfa6b2b1eb50f6b53bffadb2a40bc1fedc5bc16dc080c"
    sha256 cellar: :any_skip_relocation, catalina:       "fc40fd1461a29a7c19de30a25849245c9ca5ffb1f4550bc88f8cd5b52a61a84d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "916beb49312ff97ac89802ff77062ed5c6fe6eaf6e3e1d4194f41b5e594a93ea"
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
