class Shellz < Formula
  desc "Small utility to track and control custom shellz"
  homepage "https://github.com/evilsocket/shellz"
  url "https://github.com/evilsocket/shellz/archive/v1.1.0.tar.gz"
  sha256 "8bec29e04a54adb8b9d161c88422d324e1f3d52d743f4fc0d72ab89ca54f9c1e"

  bottle do
    cellar :any_skip_relocation
    sha256 "586429477cb29a4947f2a2dff5727ae818957d330f78a8c28838f0c68fc9745f" => :mojave
    sha256 "9543e2e0ce043a3a36a27ee17db633a05b1183c4e159eb9ad06338e68e7d5aff" => :high_sierra
    sha256 "f84673840eebbeacc1e0e17ac6ce6467019373c8615120f5fe990aafdb059fda" => :sierra
    sha256 "6f0ec386ee44e427b0f95dc12c3f047c47eb6a1072501169df4529aef7f7af60" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/evilsocket/shellz").install buildpath.children

    cd "src/github.com/evilsocket/shellz" do
      system "dep", "ensure", "-vendor-only"
      system "make", "build"
      bin.install "shellz"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "shellz", shell_output("#{bin}/shellz -help 2>&1", 2)
  end
end
