class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.61.0.tar.gz"
  sha256 "dda6a781182a93ed067fd2e73e6a5a183c355cba21f1bc958c4297e50765874d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31835165e409adda95c587328cae1da5c3910fdcc3e2c16f9bed9f06e4cb2100"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3eb6295704f374390a6714b6c8a865fc03a4f0e5ad93bfcfe6a832825c32e43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b7f8e61646ebea6263ee9c9937a2a8beea3f6060d63324266512a48babd0bf4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6af3c5299450117ac8bf5dbfb204840f32beda035769c1c0a056fa041ee5461"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f99c9b5b3bb31ba3f84aab349b3dd7c5e59b38f3df5d61de138ad8c92b3d247"
    sha256 cellar: :any,                 x86_64_linux:  "eb0eff6fdaeaf4b7debce86082061b8cbc909c403b7bfddf99ddb68e5b868549"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output("#{bin}/scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end
