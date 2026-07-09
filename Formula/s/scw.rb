class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.58.3.tar.gz"
  sha256 "1a9b2533a573309794276c8a862683a360408a35256a0da125d7f94c78a105c8"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0af132610f540bb555c929ee11daa3ceae64629777646b7e7321ebc965c447b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03372c2be62155697fe67e3615dcfb2a1e4ccaa018dfeb12108fb266cbd4f01f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f18d2d69da32ae1916a7696198768d97c1b82de9e7ede499920f7ebf02c200c"
    sha256 cellar: :any_skip_relocation, sonoma:        "005ef7983cba72ffeea9307d52beacdaea606e1cc3c6f473eead8cf269a8996a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86f36ca41bb3d3043c66af6b33df20b7071c71d5200f88cec1f14e91e3d7c87e"
    sha256 cellar: :any,                 x86_64_linux:  "2864694b385f558ce4f7e3344221a6e9a7df5496f1b1b7a6a362e4dc5af354b7"
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
