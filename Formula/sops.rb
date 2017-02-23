class Sops < Formula
  include Language::Python::Virtualenv

  desc "Editor of encrypted files"
  homepage "https://github.com/mozilla/sops"
  url "https://github.com/mozilla/sops/archive/2.0.8.tar.gz"
  sha256 "83f1b0e2ccf3b665e20a22c2dde90ff6e0905033f8457d2a17753e2d35f82eb6"
  head "https://github.com/mozilla/sops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a7a73cfb3fd56e2b8b9f1e57e89a65013f6d84b04f3ba57e53ce050409ce971" => :sierra
    sha256 "0594d0c02f8dfcc0717cbc59c2c4962bfa7b2cee43e108dff937d9948c7f0e08" => :el_capitan
    sha256 "3ec75075f0de2c93f67950e226c4f1ca63199abb4d0d3871ca4b4dad0bcfa443" => :yosemite
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
