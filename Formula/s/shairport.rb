class Shairport < Formula
  desc "Airtunes emulator"
  homepage "https://github.com/abrasive/shairport"
  url "https://github.com/abrasive/shairport/archive/1.1.1.tar.gz"
  sha256 "1b60df6d40bab874c1220d7daecd68fcff3e47bda7c6d7f91db0a5b5c43c0c72"
  license "MIT"
  revision 1
  head "https://github.com/abrasive/shairport.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "6ec34c1a6192a444706e3bec92cb08424651737c23428cf32bd09fb87e08ec22"
    sha256 cellar: :any,                 arm64_monterey: "cc2f0f9f0a61452bbc6024ff53289c9769478d6c869e14c6b82eb122c2417e61"
    sha256 cellar: :any,                 arm64_big_sur:  "4ec084bdb28e1a1402ea518d2a7f9342ba3310b2b69d61e41c4aa1cbcfa2cd0c"
    sha256 cellar: :any,                 ventura:        "bf78aa5d7f7dac89cd5a98ce2b953ad02a439cf07ac22c48e7a7c50f805328cb"
    sha256 cellar: :any,                 monterey:       "50066fb9c883277e109868b5023557545c56ed1424f3b2dae4b39c7491f09203"
    sha256 cellar: :any,                 big_sur:        "241a4d9155fb3a9c0e0e5f0fcb46c79e9d1febf07d09780d0865cd80379fdfcb"
    sha256 cellar: :any,                 catalina:       "eb61653e41a172eef6f5458c35e7f8a3627d730e44c2e361903cb75b96fd747b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "510b4ed23f8c1c12f5a2c756bcdeaf4e7b86ff0574b29b951b9b26c806a29cf4"
  end

  # https://github.com/abrasive/shairport#shairport-is-no-longer-maintained
  deprecate! date: "2022-10-16", because: :unmaintained

  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  def install
    system "./configure"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/shairport", "-h"
  end
end
