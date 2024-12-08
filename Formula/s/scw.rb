class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.35.0.tar.gz"
  sha256 "d787031659db7ba2ac0f12e26b924aad9776dc108d4350d35cb67d9c465b2b00"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "614ffc99584f69e826f981795a4a6ca15c63b32d3de30aa4c5c528d9a233c10a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "614ffc99584f69e826f981795a4a6ca15c63b32d3de30aa4c5c528d9a233c10a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "614ffc99584f69e826f981795a4a6ca15c63b32d3de30aa4c5c528d9a233c10a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f68a34d87c813c99adba55711778c2fb4d8625a3f40251f8c516f38deb9e9ef"
    sha256 cellar: :any_skip_relocation, ventura:       "9f68a34d87c813c99adba55711778c2fb4d8625a3f40251f8c516f38deb9e9ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92f53c48d9cff7fed2aeaf9cf5f6774f99142eb214dfe2d0648953e5b7e6e1ba"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output(bin/"scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end
