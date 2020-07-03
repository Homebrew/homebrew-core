class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.8.11.tar.gz"
  sha256 "33a33cad8ed06ca5846117d3a0be539998361f62e0588aeb0981b1abf4f2563e"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "39ba9e19effc64a538cc21f815f4cf5483eb9dd27ba1071f2dce00f520886e28" => :catalina
    sha256 "60120bd63a18a3bb0b90efd8a46da75d54fb8e88a07d5037eb807dd6a11a54be" => :mojave
    sha256 "c410bdddbcb85d58dd8d0f540255b532568ddf9801faa1a1bf43f14fa67c0612" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/yaegi/yaegi.go"
    prefix.install_metafiles
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
