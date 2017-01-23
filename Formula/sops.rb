class Sops < Formula
  include Language::Python::Virtualenv

  desc "Editor of encrypted files"
  homepage "https://github.com/mozilla/sops"
  url "https://github.com/mozilla/sops/archive/2.0.7.tar.gz"
  sha256 "d916714370bfc5d118607e6a48e54844d1caa93a4a4ff89d884a788651cbb9a3"
  head "https://github.com/mozilla/sops.git"

  bottle do
    cellar :any
    sha256 "95038acdf38ef6bf5f0b9a2f909f342687901c35bfabd71419b70c02cf295251" => :sierra
    sha256 "0f74494ae92478cec3ce6ebf6a7b88fa8245a7a924adec75f657ddd8000135e3" => :el_capitan
    sha256 "e19f9bdd0588f733b3fdbaaa4470e675acb0b03c476337ae49e138cd94908525" => :yosemite
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
