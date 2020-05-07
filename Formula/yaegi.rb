class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.8.5.tar.gz"
  sha256 "c1190b3c9cd805929a0a7330cda76f373cd638639006feff1784096bcaade872"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "feec0db4f87ae008071ed62f247236a1023bb05c61bd816eaa45feb1d7ccf375" => :catalina
    sha256 "b70a61302fc437ebb118832bba5ba0adcfc9f6fa99e241f0bd055f1f1817a4e2" => :mojave
    sha256 "3f833210c0a544381a52b3bd7c83541b82124f576a977b5d77365d69412121b1" => :high_sierra
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
