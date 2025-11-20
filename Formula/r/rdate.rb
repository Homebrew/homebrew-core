class Rdate < Formula
  desc "Set the system's date from a remote host"
  homepage "https://www.aelius.com/njh/rdate/"
  url "https://www.aelius.com/njh/rdate/rdate-1.5.tar.gz"
  sha256 "6e800053eaac2b21ff4486ec42f0aca7214941c7e5fceedd593fa0be99b9227d"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?rdate[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "a83472ff648a0aab17ffdf054be07f4d486506c3b17391d656527b492a6d26d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bbf44b1f5bca7ad76c78766af7c76e1897e391a40841c1f373d4172e0fa88dea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "896cdf111b9e81a2c1fb3d1c17bce92ac51a4a8af14d0b02979543013353acc7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0bd69ad7d1cf67af981ff2b0ea4d6bda4f7860a8568de2dca05f5b2bb96e222"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0de4bc85f7374d04a639fb682bdb6108a4b2a2bd2d97c4a7f2d79ce897e5350e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3606f3683c8c1465c87a5c3fe427c4e067420f7de3ff4abdabb61871105e190"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f5d287e87f00c9a07425fdcfc63d9277faaba095fe9111737ada0eba7c7f5de"
    sha256 cellar: :any_skip_relocation, ventura:        "47d99c2597971f7a34e1fda26735afe5c728c64973513f1aa03ab4761110268c"
    sha256 cellar: :any_skip_relocation, monterey:       "5a12e0fcd7da29e05eaff27265ee4e6ccb6579d691bea8ff46859bd645ad82f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "afe7b66e5e3a57f51a7a87567026c8b9688f4b7f0c8fd03314d400164c4ac532"
    sha256 cellar: :any_skip_relocation, catalina:       "68597f7989ddba1ff853f54c0cf3adf36b3567268b69ca43d7b0795d290304b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "92c6174db1497fb979606efb3ef9ce126eb725d6b9266ba25d7414fee49f5b46"
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
    system bin/"rdate", "-p", "-t", "10", "time-b-b.nist.gov"
  end
end
