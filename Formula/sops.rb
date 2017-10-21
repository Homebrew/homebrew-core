class Sops < Formula
  include Language::Python::Virtualenv

  desc "Editor of encrypted files"
  homepage "https://github.com/mozilla/sops"
  url "https://github.com/mozilla/sops/archive/3.0.0.tar.gz"
  sha256 "28c5424e48b5b0b8c5cf471ea39954107c5bda06a3817d67f0b8c49f80aa4a94"
  head "https://github.com/mozilla/sops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3dedf944ce5698912fcf9172156a336ce168de78a1f15c0db40c3ba185de46aa" => :high_sierra
    sha256 "21d0532514798628c5af33c92ec3adea09a6ca07ad3c404d918d6211c6164efd" => :sierra
    sha256 "ce7144a246937c7626cbc11ce5b08fe8ced6820ffa64eba7198c88d3b8feb11e" => :el_capitan
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
