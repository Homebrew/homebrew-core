class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.50.0.tar.gz"
  sha256 "51722eab5fb4015cd4b0d48c2c466390cc776e3509498639355a401d2d16e53a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50fce8fdb5d8b96e103b12467dcaeeaa1939e92164bb525c750df04e6c7ad41e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1bdfd8c7ba0894353d8f802af4c6238bdf6a6cf0ee144c5010bc628755f3712"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d18e589a0ccbcf04b1fa8e2443ca9bdf7c47eaeb389c7c0810275a2b5c7f9cc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fa3fdc4fe9a56711ca1722fb838bf834c68410877574aea01eaaad6df34642c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44b64f651afb805736f924e1ef78140e540ab2d0fa1633df023d565a5918c45c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "280861039a21484b4b1cabbd81693e89ad57ff7bd4206b978aab915f63c9c2e0"
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
