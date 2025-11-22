class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.46.0.tar.gz"
  sha256 "814705b52555bc3fd6f1da84fa42aa0aa91315c164f390964a6b7de78212287c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b044c3605b247e9822747afaf31c3aa4da29cfbe17a994b8ac3d023b017e1db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af9b30f7ecbd1212d07f08f74872dd39fbe1dbb414b303f6a31d5de8aaa31d39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1228bf8a68846d7be397cd38e46e23b6169d7ba9f7a199e9013c6ab88995b2a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "3aa226d3c8d851cd49c97cbabd2b6d4d4278550a81d60655a79daed086bd78aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e2095e47606242a0f61407c4199add87899170898f1ffb155a58a7e71d8a892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3226309bfc4ceef89b8e4ddf6b11186bd78953df973891a9560e6904f65275c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output("#{bin}/scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end
