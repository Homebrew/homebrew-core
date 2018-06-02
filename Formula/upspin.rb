class Upspin < Formula
  desc "Upspin: A framework for naming everyone's everything"
  homepage "https://upspin.io/"
  url "https://upspin.io/dl/upspin.darwin_amd64.tar.gz"
  version "63f1073c7a3a0fe6162849630916771c15ed80e9"
  sha256 "65957b27817f003587267af25b8cc2c665aad4d63fc62bf7c59158ac4796ed9f"

  def install
    bin.install "cacheserver"
    mv bin/"cacheserver", bin/"upspin-cacheserver"
    bin.install "upspin"
    bin.install "upspin-audit"
    bin.install "upspin-ui"
    bin.install "upspinfs"
  end

  test do
    assert_match /^Build time:\s.*UTC$/, pipe_output("#{bin}/upspin --version")
  end
end
