class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.472.109.tar.gz"
  sha256 "38c7fadad0c8933b83d5da94253a303811df570a77dee65266ef03296e1bac50"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ab31aeed7b2adb23b16f78283aff26144668c47365e184c397e0d87e55e4ed2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5ec276607f47db93be0b6149458474f8d317930f524653c5e6951878f45364f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f316bc419caa4a7fb101a2cb8490d43bc70eee290dcbc287e5d57e06791c260"
    sha256 cellar: :any_skip_relocation, sonoma:        "559e2c6b69daf4d1c659bc301c3cba526737fa6333e5d636773d5382b1250a74"
    sha256 cellar: :any_skip_relocation, ventura:       "3210c11b75f078c816cee4b19fe89db4aa6fc80691eaa84559e55a6a2c88a095"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffade0f0dbbde439e063dde6390250f5c1e92ef0e9a12c1359b8fc55774ca196"
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
