class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.2.3.tar.gz"
  sha256 "769920b3a2f94cd2ac260c0e1bc25639af17776383e6d1cb60cc870af9576d58"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb40d52604cdc46e367c24b3f7b257f85cd62662b318727dd60c7bd21f276ea8" => :big_sur
    sha256 "912d17973d30be335b52c4e5ca1fef815d7541bd123c8ca0a2b86ddc51b7844a" => :catalina
    sha256 "669d8271919aeef4b85cca428aecdc614164147606f990c069c094a4a82d5765" => :mojave
    sha256 "70d717f4aecdbeff784a11897f009bec361ae8e787d3bb14d34275d6e6c799c7" => :high_sierra
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
