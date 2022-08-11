class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.5.4.tar.gz"
  sha256 "1d6f0f0b334ca676b764f91551bc9b9b22665c5f23e6adf43ae0e09d9adbb50c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "719e02be8a7450a9dbde4e65eb316daf2db6ca5e4982ddba0578e80a93ea3e71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7301e76d91b53ea9ea508ce00da4f801b510863a2b6dc0570a54e7bd9137b034"
    sha256 cellar: :any_skip_relocation, monterey:       "223fef190924fabe2d50b4adb5aefd98f9ebf36b915c880b6c642a12b04ae264"
    sha256 cellar: :any_skip_relocation, big_sur:        "584aa97b80769a97cbbeb12c6c586f945ff322a402c9add8b792b3094c6686c4"
    sha256 cellar: :any_skip_relocation, catalina:       "801ce8652fd506e7f5ce28d3d097c0580f0b3b4991bcc047b7ed1a17bb41d5fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "970afc9e516bef403270cb18ac969f1a710a9925ba2c7d3dcb542189b2a39d8b"
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
