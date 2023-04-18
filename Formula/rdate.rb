class Rdate < Formula
  desc "Set the system's date from a remote host"
  homepage "https://www.aelius.com/njh/rdate/"
  url "https://www.aelius.com/njh/rdate/rdate-1.5.tar.gz"
  sha256 "6e800053eaac2b21ff4486ec42f0aca7214941c7e5fceedd593fa0be99b9227d"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?rdate[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0bd69ad7d1cf67af981ff2b0ea4d6bda4f7860a8568de2dca05f5b2bb96e222"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0de4bc85f7374d04a639fb682bdb6108a4b2a2bd2d97c4a7f2d79ce897e5350e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3606f3683c8c1465c87a5c3fe427c4e067420f7de3ff4abdabb61871105e190"
    sha256 cellar: :any_skip_relocation, ventura:        "47d99c2597971f7a34e1fda26735afe5c728c64973513f1aa03ab4761110268c"
    sha256 cellar: :any_skip_relocation, monterey:       "5a12e0fcd7da29e05eaff27265ee4e6ccb6579d691bea8ff46859bd645ad82f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "afe7b66e5e3a57f51a7a87567026c8b9688f4b7f0c8fd03314d400164c4ac532"
    sha256 cellar: :any_skip_relocation, catalina:       "68597f7989ddba1ff853f54c0cf3adf36b3567268b69ca43d7b0795d290304b4"
    sha256 cellar: :any_skip_relocation, mojave:         "2d4c93b21caa56d3228d8ff2ff790f4142421ad6316cd74d77c568e84602a996"
    sha256 cellar: :any_skip_relocation, high_sierra:    "02e41a79e9aca3bad86802e1bc32c7148e8a2ea2f410c57765f9e9d8b2686fd1"
    sha256 cellar: :any_skip_relocation, sierra:         "9f4a6300d6d3ebc9034abeb5388fd40face1f286a7b97610b6a40a1dcdf166b5"
    sha256 cellar: :any_skip_relocation, el_capitan:     "acb2ae5951a0f32cbdce39e02d86c63cdb85b41fd02aff74aac6ea4939d71d8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec0afe4b9ddec866160a04e76ce20f253c90a716c6a90c66c8185db9a32f5070"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    # NOTE: The server must support RFC 868
    system "#{bin}/rdate", "-p", "-t", "10", "time-b-b.nist.gov"
  end
end
