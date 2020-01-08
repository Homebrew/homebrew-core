class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.7.2.tar.gz"
  sha256 "1f2e63290614e26ffb82ef16af23d0ce5237c10a19a5c1191c22398adb62bc1e"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5517621b05ea0055cfe8796f0f8647c93d6c45b34e0255b4db55dec36e15bac8" => :catalina
    sha256 "2acdb0bd72e300f83ad712dd7e4ad5be2d12d93ac12a86ef68a065b297e870c0" => :mojave
    sha256 "e4d8208996f9595298c4602e71c29d4e6862854036cb5b758958adffbe5336ff" => :high_sierra
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
