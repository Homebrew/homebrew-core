class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image/releases/download/v1.1.3/source-to-image-v1.1.3-ddb10f1-darwin-amd64.tar.gz"
  sha256 "b5d179e1da3e5e3d4b206a767c69bc6d5860d82227a475ecc17c4279bfb0f862"

  def install
    bin.install "s2i"
  end

  test do
    system "#{bin}/s2i", "create", "testimage", testpath
    assert_match(/Dockerfile/, shell_output("ls").chomp)
  end
end
