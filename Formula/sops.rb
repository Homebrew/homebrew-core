class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://github.com/mozilla/sops"
  url "https://github.com/mozilla/sops/archive/3.1.0.tar.gz"
  sha256 "9be1ea2d21951e09b7c8da94e6fedd1fa0f3d848fd4ebc84928748819eb00a3e"
  head "https://github.com/mozilla/sops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d5b1991504cd5410a1ff9a6ee08cbdd6f7aff20c88e79fe3243aaff3e72aed2" => :mojave
    sha256 "649a8d5c678093e7b8cb0bf50011d78393524a074b06722af77f5a6e9c8bb137" => :high_sierra
    sha256 "27521ebbb4a107a3fdab7f299a6c5c6ee6383d3ce7bac9a9ee993b12e5f96d7b" => :sierra
    sha256 "8935a31aa3d51399396360c2af50ff3d4ed17547dd111be41651974da426b0b5" => :el_capitan
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
