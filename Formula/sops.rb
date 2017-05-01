class Sops < Formula
  include Language::Python::Virtualenv

  desc "Editor of encrypted files"
  homepage "https://github.com/mozilla/sops"
  url "https://github.com/mozilla/sops/archive/2.0.9.tar.gz"
  sha256 "2d2695fe3d2bd852c293560b3376711d460b66084e6bb2c218d9b5e1c4d651da"
  head "https://github.com/mozilla/sops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "37febebf9fc1fde4f24447193b813b3d10591a5ca6726ef56c1c7f484d366abc" => :sierra
    sha256 "7d73a691780a7f2ea4988d92ee1699b15834f5fa85ab6ed9130dd9e481aa9239" => :el_capitan
    sha256 "823208d974408d4a1c0838f6c6f35e8aa5c0c4ccdb22732e675bcb611c582004" => :yosemite
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
