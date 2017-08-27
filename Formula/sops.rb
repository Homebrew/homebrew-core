class Sops < Formula
  include Language::Python::Virtualenv

  desc "Editor of encrypted files"
  homepage "https://github.com/mozilla/sops"
  url "https://github.com/mozilla/sops/archive/2.0.10.tar.gz"
  sha256 "24d661be7ba6fb80f4c501428ba81927f83a776af4ce1ecbdaf71cdd00d7a25d"
  head "https://github.com/mozilla/sops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd104ce879955051885a858826c2e4be8bc4648c86c065a6ba159c7cc34f81cc" => :sierra
    sha256 "c3dd0cd6a5d754d4eb606cf4a45fa2a97bc6774a3902fc908f0a391bf015af10" => :el_capitan
    sha256 "386187edb6b52600f0ba08a46b0838090cb76efdd3933c07e7984afef0b35214" => :yosemite
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
