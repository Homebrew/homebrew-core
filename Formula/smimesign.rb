class Smimesign < Formula
  desc "S/MIME signing utility for use with Git"
  homepage "https://github.com/github/smimesign"
  url "https://github.com/github/smimesign/archive/0.0.10.tar.gz"
  sha256 "c2036abba5f38b42acc40f311176a7af0bef7f9cc4f6c0454ba51d2335631db3"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0cbf13d18db1d8a4180ba64b0e8bdce2cdfe1606f5971e3279b479ce4ab25f6" => :mojave
    sha256 "8cefaada51c04e30ed05bd05769c62c5211ace0df3bd2bb50558ce2db4bf6577" => :high_sierra
    sha256 "22cedb6da429fb67b41f8ff952c8ceca6321403d8c7e98a8713a4ab2ca328b97" => :sierra
  end

  depends_on "go" => :build
  depends_on :macos => :sierra

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/github/smimesign").install buildpath.children

    cd "src/github.com/github/smimesign" do
      system "go", "build", "-o", bin/"smimesign", "-ldflags", "-X main.versionString=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/smimesign --version")
    system "#{bin}/smimesign", "--list-keys"
    assert_match "could not find identity matching specified user-id: bad@identity", shell_output("#{bin}/smimesign -su bad@identity 2>&1", 1)
  end
end
