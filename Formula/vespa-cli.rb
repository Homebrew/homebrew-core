class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.76.18.tar.gz"
  sha256 "aaa3dbfdce8c78bacf4a11d1099fd23c7827a6f4f943ed8e2422a351ce1f856b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb804cda7254a8f2fddaefdd92d83bf24bf8e27ec76418c878ab6890e0e51ae9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5e0e98132eded04ba313ee35841d993a3ac8708ee353985228c34a972663b1f"
    sha256 cellar: :any_skip_relocation, monterey:       "ac94d1b2168a0a8a2c9df4c1acf5e5a95d9ff710a48e9f2852e0817eb4491311"
    sha256 cellar: :any_skip_relocation, big_sur:        "f62ad105e6231c51b2d1bd1fff43f4a1aed865746cc470102984f0179b643919"
    sha256 cellar: :any_skip_relocation, catalina:       "a22af00005c1026807d82ef262f22e8a4fab34c51a744f79122c8597643fa654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee73e54434666fbff472e04f1dfb5eeab3deaecbbf7b5464a610e2b4d2875b57"
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
