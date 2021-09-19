class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.10.0.tar.gz"
  sha256 "3eaf52702e8cde067951b67a48c011370dfd335a21e9ae93e60df0174132634f"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "17c4ee9c1c3ee094e30fc0e89c3890b1de52acc9e3bd2565677ceb841e3f77c8"
    sha256 cellar: :any_skip_relocation, big_sur:       "ee94f53273fbb3375f7c86fb433c10e90940ca0a4e23ac9e02de613f4d7f47ac"
    sha256 cellar: :any_skip_relocation, catalina:      "5a9d1de5dc490564cd3e05da48aaedaf1d0c9ed57730d7d8a26311b0f08263be"
    sha256 cellar: :any_skip_relocation, mojave:        "9e2110dcbc51188064dd8ca461674f1a6973ac5e14a5b3ff2a6f3304714b1a24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "948cec6172bc410d3d104955430873f7c4e1d11c4bf8354e56b149d18869eced"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X=main.version=#{version}"), "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
