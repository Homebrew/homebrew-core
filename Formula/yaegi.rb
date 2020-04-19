class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.8.2.tar.gz"
  sha256 "b65f33cf3af28fbb13492bad3cea791d60ed0e34af0b6e49841798100d5ea7cd"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5ea2602ec21a190801989b2d61d0ccd1953fa5132f8a923844fa4a4addc4dc4" => :catalina
    sha256 "daf0877c75fe984ff50113fbdbec67e863cfc0976f1467eb6c303eedc6b32dd7" => :mojave
    sha256 "d52e6565140649392cedf7859d3c02d7098378e505f16d6696f9204639a507fe" => :high_sierra
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
