class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.7.6.tar.gz"
  sha256 "e43209ed8b0d8ab560a6fb09d123189292659f93e10036c85a831dcafbf02ffd"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0fcf640f00765af2f50edd5daeba066df12378b3452b77ced69f2e9de2cf1e9c" => :catalina
    sha256 "b360e06c0efc24ecc1f0fe9232fc8f619258ede9db245b07052d5e978d152440" => :mojave
    sha256 "c7ec7d5fc93ba1dca9de508ecd4b616b0b5ca6f3015ab8813ff5f2c0987e1138" => :high_sierra
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
