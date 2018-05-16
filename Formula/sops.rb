class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://github.com/mozilla/sops"
  url "https://github.com/mozilla/sops/archive/3.0.5.tar.gz"
  sha256 "4a47f33e5e4e5b7bd252ec2121a07e4b1b0081f3570d51477e36a85786dd3378"
  head "https://github.com/mozilla/sops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "18d428359a0a222f65fe0b7cc5fafaae4197767e2fa84513c531587c0c6be38e" => :high_sierra
    sha256 "fa4bc5fba945cb00e5270801040c4512bc6373fd85d8718c37ac6ee20aa4a20b" => :sierra
    sha256 "da2b97548dadeb244d1273c0fb039cf0311b1d53acc98ca1d17c24c371eeb62a" => :el_capitan
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
