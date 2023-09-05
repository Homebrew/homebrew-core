class Syck < Formula
  desc "Extension for reading and writing YAML"
  homepage "https://github.com/indeyets/syck"
  url "https://github.s3.amazonaws.com/downloads/indeyets/syck/syck-0.70.tar.gz"
  sha256 "4c94c472ee8314e0d76eb2cca84f6029dc8fc58bfbc47748d50dcb289fda094e"
  # it is dual licensed, but the other license is not listed in SPDX
  license "MIT"

  livecheck do
    skip "Not maintained"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db727a32ae139eaa822db6255785076859d23f8586693a99cf76c59a65f5a578"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af0789d6b4cc6f239e74176c2ffcdef761b9da87d248405568cdac1aa9ec3c48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00e98131174e989c13cde7eb0564b19581f0a60f0a5786c39d017ba7cd1ae893"
    sha256 cellar: :any_skip_relocation, ventura:        "ed01cbb1fce9251ef7e957b1e449bd0e5b6233804f0ab5c0ff5e6694c4f573e1"
    sha256 cellar: :any_skip_relocation, monterey:       "a854609908189dcfc4de73c7213104e4d3b35ed4583bbe0e86fda899817ced7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd7841201573c4b79fc9f28a1b5a981fb138553e5a3fc8712ccba26b16059504"
    sha256 cellar: :any_skip_relocation, catalina:       "cc1bf3857c3d847854b54f45a25c5b1696c811f369c811521a07e2f5a4431e81"
    sha256 cellar: :any_skip_relocation, mojave:         "4baab04685bbb2fb536170a1bd069cfdec7fb5b2bc802ce6a80a4be933d8530a"
    sha256 cellar: :any_skip_relocation, high_sierra:    "a5a983847ae0e83a5f1d83adac736c602f7cce9ae00b9700d81ed766b4fe54bb"
    sha256 cellar: :any_skip_relocation, sierra:         "5a5f8c0f9a9def7ab59a052d85fbb128bc9a1c9c9b7ea2f9639109147eeba252"
    sha256 cellar: :any_skip_relocation, el_capitan:     "a2270f693ce6e8f0542f7d57dc6c8fcb731a268aee3c75a314523446c68602d6"
  end

  def install
    ENV.deparallelize # Not parallel safe.
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
