class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://github.com/mozilla/sops"
  url "https://github.com/mozilla/sops/archive/3.2.0.tar.gz"
  sha256 "7063b15b8e4a1625e3f2a64d582c424e93ee0b7292de9891dd3918ab1596c8fe"
  head "https://github.com/mozilla/sops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3da5dce6c4dbbdfa90521bd63bfeb6f9f84649149626065d59304c150453bcc0" => :mojave
    sha256 "9829b2d6fbf48db2535736ad92b876421170e28eac8cbfd3d5b5d999a927eb2c" => :high_sierra
    sha256 "9892a38517b3bbb9894bba47b72d31becd70cee86e5b912a75006b45cf90023c" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
    (buildpath/"src/go.mozilla.org").mkpath
    ln_s buildpath, "src/go.mozilla.org/sops"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sops --version 2>&1")
  end
end
