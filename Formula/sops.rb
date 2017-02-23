class Sops < Formula
  include Language::Python::Virtualenv

  desc "Editor of encrypted files"
  homepage "https://github.com/mozilla/sops"
  url "https://github.com/mozilla/sops/archive/2.0.8.tar.gz"
  sha256 "83f1b0e2ccf3b665e20a22c2dde90ff6e0905033f8457d2a17753e2d35f82eb6"
  head "https://github.com/mozilla/sops.git"

  bottle do
    sha256 "3bba826e5df2d67210c94b0e411afec3ee5786e95a55b6e2a2637f9677e28a01" => :sierra
    sha256 "ce276dd1fd34cf5addceab033810852287b20f6644a36d58e1b17dc32fbfe90f" => :el_capitan
    sha256 "0a6e44204f38a8597111f91827d1144d1d3dbb94828464eb00f47569d5292570" => :yosemite
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
