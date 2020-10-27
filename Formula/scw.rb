class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.2.1.tar.gz"
  sha256 "6b1a0ae01f7411bb0c10e61981b18674a3b686dacef4a455275bf793411876ff"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6eeba561b3bdbe6dff8ff4f49c5bf33d04e2156fb00c6cc5d50c8241ff93476b" => :catalina
    sha256 "7cbf5837c44e54e63cece810fbb94d3a4ff41dc1a93fd6c9332fd624e43bd17d" => :mojave
    sha256 "9137a7a6ca1766eeec847760ce8c93087cd8858e8b9bb2465ef5856de80b4b81" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/scw"

    zsh_output = Utils.safe_popen_read({ "SHELL" => "zsh" }, bin/"scw", "autocomplete", "script")
    (zsh_completion/"_scw").write zsh_output

    bash_output = Utils.safe_popen_read({ "SHELL" => "bash" }, bin/"scw", "autocomplete", "script")
    (bash_completion/"scw").write bash_output

    fish_output = Utils.safe_popen_read({ "SHELL" => "fish" }, bin/"scw", "autocomplete", "script")
    (fish_completion/"scw.fish").write fish_output
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output(bin/"scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end
