class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.8.3.tar.gz"
  sha256 "d40d6784a90bc435632c325e3b574ec82765e83689a56ffd169e13087f623d6f"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7635e1ab1126153203e48e2f910f29f2d31ad2535ad94bac7f8097fad622b98" => :catalina
    sha256 "e83d5caa79669587a310a9042ec16cf6e2e2f42a7135aef3307b5906169cba93" => :mojave
    sha256 "70fae48a069fbfc412b988ca2e80f101ed8eec3c3c49eaf1c6d750c4d80f141f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"yaegi", "cmd/yaegi/yaegi.go"
    prefix.install_metafiles
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "3 + 1", 0)
  end
end
