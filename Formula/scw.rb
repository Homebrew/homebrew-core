class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.14.0.tar.gz"
  sha256 "d5335cc3638273fce42fad305683e8761e1648f59f93a6c110cc0c74c75d1c36"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa2d1e8be3e029f8b97e16ee8e1619346c169ae22c171be22808c04a9dfeb529"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa2d1e8be3e029f8b97e16ee8e1619346c169ae22c171be22808c04a9dfeb529"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa2d1e8be3e029f8b97e16ee8e1619346c169ae22c171be22808c04a9dfeb529"
    sha256 cellar: :any_skip_relocation, ventura:        "2e42817785b19929757b793cbef2fe35980b79d14b51f487900835c40d56f355"
    sha256 cellar: :any_skip_relocation, monterey:       "2e42817785b19929757b793cbef2fe35980b79d14b51f487900835c40d56f355"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e42817785b19929757b793cbef2fe35980b79d14b51f487900835c40d56f355"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e671906950555a1d767dcc5dfd0d8738a69b1b46a77200882d36a9994d9e794f"
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
