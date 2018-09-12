class Smimesign < Formula
  desc "S/MIME signing utility for use with Git"
  homepage "https://github.com/github/smimesign"
  url "https://github.com/github/smimesign/archive/0.0.1.tar.gz"
  sha256 "13789368b1379aa2ad52bce5b855b56ca88f684ed0dff42adf107ee9738187b0"
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/github/smimesign").install buildpath.children
    cd "src/github.com/github/smimesign" do
      system "go", "build"
      bin.install "smimesign"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/smimesign", "-h"
  end
end
