class SomagicTools < Formula
  desc "Tools to extract firmware from EasyCAP"
  homepage "https://code.google.com/archive/p/easycap-somagic-linux/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/easycap-somagic-linux/somagic-easycap-tools_1.1.tar.gz"
  sha256 "b091723c55e6910cbf36c88f8d37a8d69856868691899683ec70c83b122a0715"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "6efbacaa2b232898e3149d4392e6a6575cc34835b34cbf268bf73ddce6aef79f"
    sha256 cellar: :any,                 arm64_sequoia:  "6df28d78f161dc5a7e4a53d329db5c191848fe0c50abf3d7b0d71019d0ccbdae"
    sha256 cellar: :any,                 arm64_sonoma:   "1c378cda0ff89daa67d23c9747b812fc59ada83f8c7126cf894858a3f6846b8a"
    sha256 cellar: :any,                 arm64_ventura:  "adf9589e1d98e6eb49dc00765508d920b9f2acd79a91d92da79033f1a9aa8957"
    sha256 cellar: :any,                 arm64_monterey: "37c12048bc0e6e020317c308bf89b4b7725b483c8b4dde598b83beda176839f7"
    sha256 cellar: :any,                 arm64_big_sur:  "072982afa9d598410ddab9dd2ef09298a4f5b080b11eb982e1b6c5ba23a441b4"
    sha256 cellar: :any,                 sonoma:         "ffe90e516c24b562929fc989c09a2e29b8836ef3d3f1aa3687b9142876507900"
    sha256 cellar: :any,                 ventura:        "14d78478d89843bf095cc9bfe37d1df550b9344f7d5453d7a54ae61a55febb7a"
    sha256 cellar: :any,                 monterey:       "6307d97300f3ba6bdd7b8d63c3fcf01dba6329713e5fefb1c81c042f07fb0041"
    sha256 cellar: :any,                 big_sur:        "e96911a936eb3ed42923f4cba1f29dcc96f624ea5f6209b153b0922ee529d20e"
    sha256 cellar: :any,                 catalina:       "59d88127409e26497afa4bb7d3afa04820dd1ccb56542096e01c85c733e53045"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "aa90bfa3a829c6d5073ffd2f7552173c4b33174aec52a32a75702a7bb55e61d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6a63036040014c766c494998f69b3be27f0ff5dccee6deba1a0f8ac7c6a05e3"
  end

  depends_on "libgcrypt"
  depends_on "libusb"

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
