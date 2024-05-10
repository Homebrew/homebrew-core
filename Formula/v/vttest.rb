class Vttest < Formula
  desc "Test compatibility of VT100-compatible terminals"
  homepage "https://invisible-island.net/vttest/"
  url "https://invisible-mirror.net/archives/vttest/vttest-20240218.tgz", using: :homebrew_curl
  sha256 "625b292f8052ffbbefe7d9d6fbdf9c8d1fc18b5c85568f2547097d97c540bd75"
  license "BSD-3-Clause"

  livecheck do
    url "https://invisible-mirror.net/archives/vttest/"
    regex(/href=.*?vttest[._-]v?(\d+(?:[.-]\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d11590b944ee0dc4ee1f510141f923b43e82dc9e9c759bc4d7e8c1a3879eb4d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d2e5081924f0ac1c6895fae2c4a72971a12cfb6a584c2a0e95f4a5b79f885cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50b99e7ebf8c7af162d6ba35fcfea9b4188cfad550a992b495060df74076304e"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a6288bea0cb31358fea9c5cda2aeb40b177883331cc7fdfb3f2ab0778afb58d"
    sha256 cellar: :any_skip_relocation, ventura:        "14b186e7a6a33297998a92a365522d6479e3e19c6a225cf86591c908c3bdc703"
    sha256 cellar: :any_skip_relocation, monterey:       "f1880f38913bc8d31f57eaa60fd21d4a92c4bbb3b505b998ef9551ae108f138c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8554cd06e7ee6cb4a0be4520f416dd64a908adc1c44659b01e6d7027bcc07e4"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output(bin/"vttest -V")
  end
end
