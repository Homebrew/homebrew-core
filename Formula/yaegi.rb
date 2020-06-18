class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.8.8.tar.gz"
  sha256 "5f74283fc7edaeb4316c0f1449998085d1be8a30cd59cc3d865082e2d14eb1c1"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "853c55e3d647cf6651551fd4de0f1624d5b0b603ab2ff9bd1124408fdb35135a" => :catalina
    sha256 "5475f92558e0d343585cb94c3df2f3c7000edb1f9954d2a2bd4a46da17055c8e" => :mojave
    sha256 "f5ea0ec977835299c5897df6786015741d75e488fda71ebf8d219ad88fe48938" => :high_sierra
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
