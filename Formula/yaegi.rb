class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.8.11.tar.gz"
  sha256 "33a33cad8ed06ca5846117d3a0be539998361f62e0588aeb0981b1abf4f2563e"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed16046653b93e18b4d692493f8dc1757cf6f331a14e8ceb020a2818ac9ff412" => :catalina
    sha256 "e69ca038967da39477d1bcb67c757216908a3a2f156ef1f21674fe6197276899" => :mojave
    sha256 "738ef2f625c085e272b852e62f839ba3111c01fa52f8064ac8148208104fd91d" => :high_sierra
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
