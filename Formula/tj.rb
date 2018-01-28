class Tj < Formula
  desc "Line timestamping tool"
  homepage "https://github.com/sgreben/tj"
  url "https://github.com/sgreben/tj/archive/6.0.2.tar.gz"
  sha256 "c667f8fb09839a677bd6b3d6c06103bce59ffb2e33ec1bd7b49abfc00f02f5dd"

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
