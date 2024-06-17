class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.31.0.tar.gz"
  sha256 "cd6e95b0fb6e376aa11e06326edebdbaa30281da9aca028c2041d57359571561"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6005e819c55b865e66db5d284b7e0c4d3191e26069e78a629e929cdae800f523"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7600d20c7bcaf9c318d82008dec1838355b42b3d2044dcdaba5fd27d5843bd2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a72364fdf1dc8a2fd02110419d9df7887ac8a2a7b54c1c3cbff6618e881d14d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "75360c5f91d60b90979c37ac31c75204b6d92e8cf2ccbc2eb804d25f5484558a"
    sha256 cellar: :any_skip_relocation, ventura:        "6167343ffaa703defcd71bb6b1da26645adeb21d745bffe09c4bc9e7ef4e7614"
    sha256 cellar: :any_skip_relocation, monterey:       "964963df0921aed145fed150f8547129246824bd40d0f7ac419349a3ec332af1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43062b23e473aee07a13c9f251fca2f6c5c9b799ad4e0e2cf17b24521306dc55"
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
