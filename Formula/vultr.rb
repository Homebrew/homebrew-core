class Vultr < Formula
  desc "Command-line tool for Vultr"
  homepage "https://jamesclonk.github.io/vultr"
  url "https://github.com/JamesClonk/vultr/archive/v2.0.1.tar.gz"
  sha256 "928f6c3caf8149f836a609ec43a3d031f0206a8cba095e026535c33c390c1157"
  head "https://github.com/JamesClonk/vultr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "11edd7b69bd41bf11ceab87cc0353305612887f53ed2429ffe7034c0179f4dd5" => :catalina
    sha256 "af7d3754f0136c4ed3f0067920c0351931df48f487457ba6f12741e745e636e4" => :mojave
    sha256 "9384a5df861603c74301e8500d70c170f806348fbfdf5117b1c6d91bed7d26d2" => :high_sierra
    sha256 "a49908fc98bd2c2e2322e1d9511352ece67dbedc02879c71811d82b7c9bdaa3e" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/JamesClonk").mkpath
    ln_s buildpath, buildpath/"src/github.com/JamesClonk/vultr"
    system "go", "build", "-o", bin/"vultr"
  end

  test do
    system bin/"vultr", "version"
  end
end
