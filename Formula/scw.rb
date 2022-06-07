class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.5.1.tar.gz"
  sha256 "af926168122c192b10a19d701f2a03a41f14897b2a6c654499203edd2aafcafe"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "523bcbc6362116154c166295771973e6b4588970287a7a3f068c9a5d92a1415a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8e62fc4837bcf1a4b6c6c35e89cd04fccf4833b17145597daf4bc43a354faca"
    sha256 cellar: :any_skip_relocation, monterey:       "f041da73aefc5527c938a79e309d63865268c778a37a98e479627b255c069b8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "75c80081d91db3d17a6a198e312be40a0801b3b48df3f607fb8c422ea2c7bac9"
    sha256 cellar: :any_skip_relocation, catalina:       "e5f41d0e35b06d7f6c00d50ad5c5f62f4acda110395844956e5be5900bb0c7a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfbce028ad90322415bf84b405d6e96b45cfc49104c6b9b0eb1a2a0370982d11"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/scw"

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
