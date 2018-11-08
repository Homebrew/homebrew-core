class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://github.com/mozilla/sops"
  url "https://github.com/mozilla/sops/archive/3.2.0.tar.gz"
  sha256 "7063b15b8e4a1625e3f2a64d582c424e93ee0b7292de9891dd3918ab1596c8fe"
  head "https://github.com/mozilla/sops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "99a813300fe2b1adcb0406a1e4339d7bdf3902c4731b65b2835060c94373c2b9" => :mojave
    sha256 "bcc7b594c94c55f3a6e6abd7a0128aad10d664fe2e9a3c834262b08f4c987a49" => :high_sierra
    sha256 "5567fb1646d2834098024e055c69d20909a1a6cde7aeb48cb446c513e4ff1076" => :sierra
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
