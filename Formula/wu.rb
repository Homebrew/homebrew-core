class Wu < Formula
  desc "CLI that retrieves weather data from Weather Underground."
  homepage "https://github.com/sramsay/wu"
  url "https://github.com/sramsay/wu/archive/3.10.0.tar.gz"
  sha256 "0934771cdd04cb4c38b45190dbfa97fa8b3aafaf53ea75152f070c97de850223"

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
