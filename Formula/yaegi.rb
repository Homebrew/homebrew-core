class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.8.6.tar.gz"
  sha256 "847448c3f049c46aa722003b997e0f1f91115755a8d317854f8057b386ffc501"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d16015dc1139316b1bf9864cafd7d7bdc132accb600f043f0ab3f81f02ee53f0" => :catalina
    sha256 "7ce961873f891f3e233dbee8d0a6734aec19a3499eb3927c0bed15118303a560" => :mojave
    sha256 "f1f27ef2699107f57f9562e207a802bfb46bc1d9f4af4b9b39a1480141b14dde" => :high_sierra
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
