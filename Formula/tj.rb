class Tj < Formula
  desc "Line timestamping tool"
  homepage "https://github.com/sgreben/tj"
  url "https://github.com/sgreben/tj/archive/6.0.2.tar.gz"
  sha256 "c667f8fb09839a677bd6b3d6c06103bce59ffb2e33ec1bd7b49abfc00f02f5dd"

  bottle do
    cellar :any_skip_relocation
    sha256 "05fa676f8b78bdeb2b782d696dd0e7b0dc1aafaf4597f1bc259fc8ccd3b3f168" => :high_sierra
    sha256 "26edd5e1c71f587c3aa9be749e2d18852cde5ad406c91a9402ecba7cf3ada798" => :sierra
    sha256 "37a1cc78f74344b31c8e85dc32213f42b9bd43bb5cc015afee749254042906fa" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/sgreben/tj").install buildpath.children
    cd "src/github.com/sgreben/tj" do
      system "make", "binaries/osx_x86_64/tj"
      bin.install "binaries/osx_x86_64/tj"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"tj", "test"
  end
end
