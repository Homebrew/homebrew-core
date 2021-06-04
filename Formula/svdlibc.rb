class Svdlibc < Formula
  desc "C library to perform singular value decomposition"
  homepage "https://tedlab.mit.edu/~dr/SVDLIBC/"
  url "https://tedlab.mit.edu/~dr/SVDLIBC/svdlibc.tgz"
  version "1.4"
  sha256 "aa1a49a95209801803cc2d9f8792e482b0e8302da8c7e7c9a38e25e5beabe5f8"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, catalina:    "3c78491f3d89425e87fb7a1d5ec63845ddf86f5098f817e32f7c1aafd64aa3cf"
    sha256 cellar: :any_skip_relocation, mojave:      "dc6f967a82e022b8bd193a0f346aa50b17df609de22acda3ead9eac89b1fd103"
    sha256 cellar: :any_skip_relocation, high_sierra: "7b1c2af44513a0280c2922b22dd0107189e9872a6dc2e0476df2b8c47902cf40"
    sha256 cellar: :any_skip_relocation, sierra:      "91a70ced4042615305d39e9d4d88d91b4d971bf8bb40e883b8f7a2682bb2e729"
    sha256 cellar: :any_skip_relocation, el_capitan:  "f4e320bb8555cfed8d39a134153df533a3b921ae01827728cba36c6217bb85be"
    sha256 cellar: :any_skip_relocation, yosemite:    "da1b02f2d5758322ddcfc30b0513249f31dd1aad96fd2f3377e9edc301f7c686"
  end

  disable! date: "2020-12-08", because: :unmaintained

  def install
    # make only builds - no configure or install targets, have to copy files manually
    system "make", "HOSTTYPE=target"
    include.install "svdlib.h"
    lib.install "target/libsvd.a"
    bin.install "target/svd"
  end
end
