class UserspaceRcu < Formula
  desc "Library for userspace RCU (read-copy-update)"
  homepage "https://liburcu.org"
  url "https://lttng.org/files/urcu/userspace-rcu-0.15.6.tar.bz2"
  sha256 "850b192096eb11ebf2c70e8f97bc7da7479ee41da1bebeb44e3986908bac414f"
  license all_of: ["LGPL-2.1-or-later", "MIT"]

  livecheck do
    url "https://lttng.org/files/urcu/"
    regex(/href=.*?userspace-rcu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "97c106090ca81cb3e86be9ea95d52cb8a91b6652e5c4e4049a4ec06d66f05d07"
    sha256 cellar: :any,                 arm64_sequoia: "665d47e0ef64f5c3b29bc9788501ff9fbdae84d489bb3cbde5965140759a1b3e"
    sha256 cellar: :any,                 arm64_sonoma:  "0cf9cd46e22eb9b4002522f4dda0bfc92f6290901b13d97d033654d7151fa1b7"
    sha256 cellar: :any,                 sonoma:        "7a6692c07a9ab4ec2d9061def09dc3ddb0170702be741b4e563c00e9285df6c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7ba41748b5ed3ee19e34487067d2708cb80aa5050daacd24259c2f38fa31448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0ed3d7bc023151f2d4d73c30d3e3b1dc0a49ebd853c752233d8b1032e49e696"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args.reject { |s| s["disable-debug"] }
    system "make", "install"
  end

  test do
    cp_r doc/"examples", testpath
    system "make", "CFLAGS=-pthread", "-C", "examples"
  end
end
