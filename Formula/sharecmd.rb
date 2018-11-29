class Sharecmd < Formula
  desc "Share your files with your friends using Cloudproviders with just one command."
  homepage "https://github.com/mschneider82/sharecmd"
  url "https://github.com/mschneider82/sharecmd/releases/download/v0.0.24/sharecmd_0.0.24_Darwin_x86_64.tar.gz"
  version "0.0.24"
  sha256 "f53275c9acc1c5f28b4285e3b2ce628256e0e765bc857df545451697d6e09b90"

  def install
    bin.install "share"
  end
end
