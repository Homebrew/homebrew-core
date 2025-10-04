class Xrdb < Formula
  desc "X resource database utility"
  homepage "https://gitlab.freedesktop.org/xorg/app/xrdb"
  url "https://www.x.org/releases/individual/app/xrdb-1.2.2.tar.xz"
  sha256 "31f5fcab231b38f255b00b066cf7ea3b496df712c9eb2d0d50c670b63e5033f4"
  license "MIT-open-group"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "c4b0e238c08eae84fdc82bf3f4cfbb3ef02301126c875565a50ac269fe69b170"
    sha256 cellar: :any,                 arm64_sequoia:  "c623fd441390eaf1e39523477efd40c69f906eecc0e298db015fad002828a707"
    sha256 cellar: :any,                 arm64_sonoma:   "dd6633e16b4d7304c613cc88b59930d98bfc8bddf4e575e161c06fd74200d89a"
    sha256 cellar: :any,                 arm64_ventura:  "1b32536870feb4f744ec01f9b09dcc2b5a612b742ab527563ba5661f1f1777ee"
    sha256 cellar: :any,                 arm64_monterey: "dcb8e3ddd3e7c5fb5d362c5b761477029956d6ab1f2a7952e7a3e6e1112dc70b"
    sha256 cellar: :any,                 arm64_big_sur:  "c7aeb1ca86ab70fd43c32152c2200677446f7e7b0f376c118c7642cf5aa218bf"
    sha256 cellar: :any,                 sonoma:         "65f65a99c1a3f04506cdf86fcfbbf3ab49da907cbd60b62351ba9a9ef200290e"
    sha256 cellar: :any,                 ventura:        "7ef65e0a0e3951b600d7587ef5015ca44606cd5f225ca2c33735979633176fc3"
    sha256 cellar: :any,                 monterey:       "0681e2deb75be4bcf436002d036f7dafbdabc2401f571255c0c8f225e2cf7728"
    sha256 cellar: :any,                 big_sur:        "ea5920dfb84ff9ff1d35090dfcd39aa4995163a0bbb515f0396be1137c2d20be"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "428c35b84b33e5a752e8804297b8d6be1db36ca40068018d9db68d8bb18aad8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b387dbe59b86aad4b9e297ed43cb2bfc07b7a5c893fa22cf36e8e8712cb722fa"
  end

  depends_on "pkgconf" => :build
  depends_on "xorg-server" => :test

  depends_on "libx11"
  depends_on "libxmu"

  def install
    system "./configure", "--with-cpp=/usr/bin/cpp", *std_configure_args
    system "make", "install"
  end

  test do
    spawn Formula["xorg-server"].bin/"Xvfb", ":1"
    ENV["DISPLAY"] = ":1"
    sleep 10
    system bin/"xrdb", "-query"
  end
end
