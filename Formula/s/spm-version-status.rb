class SpmVersionStatus < Formula
  desc "Check the latest versions available for your SPM dependencies"
  homepage "https://github.com/fespinoza/spm-version-status"
  url "https://github.com/fespinoza/spm-version-status/archive/refs/tags/1.0.0.tar.gz"
  sha256 "314fe7ebc1a0dfc52b6a3b0d897ff2882982224dde4d8962e99dab1524475607"
  license "MIT"

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system bin/"spm-version-status"
  end
end
