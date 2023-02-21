class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.11.0.tar.gz"
  sha256 "036300e6b8436b777589dc7fae0544f380fa5c66653f227aaf4b22f7c5458d02"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be337dbdd0f83d2704662ccc9610f7dae9a2047448e63918ae9d3ce45089a2f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d41bf98062054e5fb16ce15b426d0488c769551a466b7032a3c508f5d051f724"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10e569c3d12139e9851a0c3df1382e8628887aa207675238275b94a8f07c54c8"
    sha256 cellar: :any_skip_relocation, ventura:        "a9b1ee47967945f1d75825768384433a3a73ca157660527cb6175b7244da4a9b"
    sha256 cellar: :any_skip_relocation, monterey:       "d33c3ecdf3748825fbaaf7abe2c13e709202c6b8dfce15a454410cef92f72aee"
    sha256 cellar: :any_skip_relocation, big_sur:        "94929bcb668ba9c9f5fd2562a48259152a93d5b97a8d80b5075294b887cc6cc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac6c6afa3059715c32829c610714b75954995fea774f357e41fe447b8b31a2cc"
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
