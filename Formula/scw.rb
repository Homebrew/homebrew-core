class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.9.0.tar.gz"
  sha256 "33a3490ab4be9053b3e4a034a6bf1c5326b435a70240ba283da571b9e2f9c512"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a3b5773a1b52e7549dcb05725296eb180c94677a27659f69aa50e28f3bb601a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "131fe8e9832d56d4187af5ebfd214d67de05c6561396b37d9972ea9cfc933713"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1f1e51d95381c89e343211a9281b6e64601803d45127c0ae62713d9a8d547c5"
    sha256 cellar: :any_skip_relocation, ventura:        "ad16c4119ae549bf23ea6c9becc38cfe0c372efc20f3e485b4b175b6a0bdbd8a"
    sha256 cellar: :any_skip_relocation, monterey:       "1e969c02186481b1cd2e336fc211d5dab3134be2c4a64e86398d5abf3f9db0f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "560b8b89598ddbb018741e6346fce3d2392faffe124525e8fad6b780d5cd5b24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "402697b0ee6ea5c929f576eb2ba5090ee08f5dc00148815530614c66c4d19abd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output(bin/"scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end
