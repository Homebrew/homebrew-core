class Wu < Formula
  desc "CLI that retrieves weather data from Weather Underground."
  homepage "https://github.com/sramsay/wu"
  url "https://github.com/sramsay/wu/archive/3.10.0.tar.gz"
  sha256 "0934771cdd04cb4c38b45190dbfa97fa8b3aafaf53ea75152f070c97de850223"

  bottle do
    cellar :any_skip_relocation
    sha256 "5efc0cdf39ff0d7ce0cb70be665118459cea9f8523f9a01bf67a341e1330fb56" => :sierra
    sha256 "bd297452f33d081c7720190bc9ef17f1c8b247de5a27c64e78fede64bd871050" => :el_capitan
    sha256 "61b96421517b20e4d6090e37ffe3b52a93ee0934ecc06e8282fd06d0bb457883" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/sramsay"
    ln_sf buildpath, buildpath/"src/github.com/sramsay/wu"

    cd "src/github.com/sramsay/wu" do
      system "go", "build", "-o", bin/"wu", "-ldflags", "-X main.Version=#{version}"
    end
  end

  test do
    assert_match "You must create a .condrc file in $HOME.", shell_output("#{bin}/wu -all")
  end
end
