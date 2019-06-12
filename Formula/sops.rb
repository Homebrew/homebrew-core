class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://github.com/mozilla/sops"
  url "https://github.com/mozilla/sops/archive/3.3.1.tar.gz"
  sha256 "9f6a4a369378cef9e8e7cdd8ba00b3105b0b6875404c3b9f482f804b2f355a77"
  head "https://github.com/mozilla/sops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b04a345c474c2fa04802d2b3330c5f2350e6eebec8c92e1159471c1475228eba" => :mojave
    sha256 "910754aae300a7e12474fc9787166228daeaf48a55fd9f77028bf224a6a2b1db" => :high_sierra
    sha256 "7a19e62b0d681550fc8416d4a51400c4dee0052b781f2897a78220f539989437" => :sierra
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
