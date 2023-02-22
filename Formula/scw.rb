class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.11.1.tar.gz"
  sha256 "ce5dcd835ecbe57db266105bf1d4879b027e4ac2634981ef8d5e904cccedb00d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b79091b13bb01d9b5f885f3b7ba7fc09c57be166e8d99567312c9e21f6a6377d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f25e644c06f8ad60d7c4ec3ce4548757509c50cb6fa4533a7988f9a3f3ed225"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a81b56c7aca11fecc4dad4c1890328795b8b77b2270e669c6ca8fc81d830e4c"
    sha256 cellar: :any_skip_relocation, ventura:        "46e817a8c7542d3ad59dfb77ad949b8bb64e93937a1858c4985d92fa280931a1"
    sha256 cellar: :any_skip_relocation, monterey:       "6631245b8c29786a3afbeeb69507bf91ce9dc3d04beb19e298af3dfc30355255"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e991c3bebe47473965ea5c7a9c2cff933d7aea1342bf5331f339822e30fe81a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf04cfd0e05636f8f8c8e4b864f7ce114c3c12ce249db1f0a2bf967f4b811e49"
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
