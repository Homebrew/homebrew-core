class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.13.10.tar.gz"
  sha256 "c67df6f7867e72c99187ebcad7c54bb100f4acc7a76fb939f647874b8b0c3ee4"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a2ed5b638be0edbbdfb01dc8c47927dd09a4901d8957e65e8d4c2af45355154"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d3b2fbc2c0802f981436b3c192a6da951e81b59accafab86630d163eb58d9f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50a9f7f8b6a56a0c789076686db10b872afe809c3c7003db674648fb55748af6"
    sha256 cellar: :any_skip_relocation, ventura:        "b4cd6293a89e3698a681849930992713b1a23b9e520a5303506db291440fdec2"
    sha256 cellar: :any_skip_relocation, monterey:       "f00206485f3e5fe233d9bfdee0cf0a6d3d249b62c2c579ae7672c369170055fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "ddcdc876e4c1c4fcffd9c075620f2a6e2c4a30543433dcdaf68a0351d82ba204"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c24f3d489949485ad3e999c1008542b996dfb9b33c6f7a24cc885014df7b7e25"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end
