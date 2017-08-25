class Sops < Formula
  include Language::Python::Virtualenv

  desc "Editor of encrypted files"
  homepage "https://github.com/mozilla/sops"
  url "https://github.com/mozilla/sops/archive/2.0.10.tar.gz"
  sha256 "24d661be7ba6fb80f4c501428ba81927f83a776af4ce1ecbdaf71cdd00d7a25d"
  head "https://github.com/mozilla/sops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "37febebf9fc1fde4f24447193b813b3d10591a5ca6726ef56c1c7f484d366abc" => :sierra
    sha256 "7d73a691780a7f2ea4988d92ee1699b15834f5fa85ab6ed9130dd9e481aa9239" => :el_capitan
    sha256 "823208d974408d4a1c0838f6c6f35e8aa5c0c4ccdb22732e675bcb611c582004" => :yosemite
  end

  depends_on "go" => :build

  def install
    # Reported 25 Aug 2017 https://github.com/mozilla/sops/issues/237
    if build.stable?
      inreplace "cmd/sops/version.go", 'version = "2.0.9"', 'version = "2.0.10"'
    end

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
