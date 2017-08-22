class S3deploy < Formula
  desc "Deploy static websites to Amazon S3 with Gzip and headers support."
  homepage "https://github.com/bep/s3deploy"
  url "https://github.com/bep/s3deploy/releases/download/v1.0.8/s3deploy_1.0.8_macOS-64bit.tar.gz"
  version "1.0.8"
  sha256 "c6d47f0635bbd821553e72414c49dd767df980622112e23e81a9edd54c3b7499"

  def install
    bin.install "s3deploy"
  end

  test do
    system "#{bin}/s3deploy", "-h"
  end
end
