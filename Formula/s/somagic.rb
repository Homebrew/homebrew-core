class Somagic < Formula
  desc "Linux capture program for the Somagic variants of EasyCAP"
  homepage "https://code.google.com/archive/p/easycap-somagic-linux/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/easycap-somagic-linux/somagic-easycap_1.1.tar.gz"
  sha256 "3a9dd78a47335a6d041cd5465d28124612dad97939c56d7c10e000484d78a320"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "f077c27f36c94d14196836cb4f397c6d720cf39a399d64da000c62d2d0faac16"
    sha256 cellar: :any,                 arm64_sequoia:  "f2c83c2ff15da271002454ee3f3b73863d3143954a5d761bcabd7a1412824fb9"
    sha256 cellar: :any,                 arm64_sonoma:   "d9d2e64b2ef72922c9602c0c17890455654ecae4ffd3b9b359d93d66bb8ad0cd"
    sha256 cellar: :any,                 arm64_ventura:  "2d42167b5e235d77834fe886a10590e23b8e91aaec16eb1ce7406ba68efb8653"
    sha256 cellar: :any,                 arm64_monterey: "cc20451f949f3dd25732f6090526d638d9d368a3dacfcd923440501788a39c3f"
    sha256 cellar: :any,                 arm64_big_sur:  "5a8bb98812f68221bf3db7667aa281e9c18b111837bf1b5167adf30e498b53ff"
    sha256 cellar: :any,                 sonoma:         "a42ebfd9151b089a6f92ab2ab34f1dfb944a08fdd9d33d9c65971e1c795de35e"
    sha256 cellar: :any,                 ventura:        "47fc6d3831206271dc2090e561f41cf6befb1245f4b935401e4cd76f08087316"
    sha256 cellar: :any,                 monterey:       "375696b4885e66a0c87c4cbefa8702bfa2c47ac9d75e7f7027f06839b0fd2b1b"
    sha256 cellar: :any,                 big_sur:        "5451a0d35aa0aedcb43d1aeb6e080804333f8f7abaa090ceab62b1d02482389f"
    sha256 cellar: :any,                 catalina:       "41d2479b3d2a267bbcd8c5db4ea7a8fe04c120d260d2ac9f087bd386012a3971"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c355af02d26d71d5f7e858ae952f8c726cf37f240ee43bfec917bd47003427fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d574fbe24e39eaf6e35a4d8317c689ae890983a801e8abf8e5dc0a2941a1104b"
  end

  depends_on "libgcrypt"
  depends_on "libusb"
  depends_on "somagic-tools"

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  def caveats
    <<~EOS
      Before running somagic-capture you must extract the official firmware from the CD.
      See https://code.google.com/archive/p/easycap-somagic-linux/wikis/GettingStarted.wiki for details.
    EOS
  end
end
