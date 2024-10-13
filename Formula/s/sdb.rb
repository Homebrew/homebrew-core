class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://github.com/radareorg/sdb"
  url "https://github.com/radareorg/sdb/archive/refs/tags/2.0.1.tar.gz"
  sha256 "053dd19eb642135d5726fa2b9cbeb394befe95e9fe607bed823de501cca34365"
  license "MIT"
  head "https://github.com/radareorg/sdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "36e0f0e49588d3ea3b588335bd7d7afd72218e517332c1aae818d8acb8f3bef1"
    sha256 cellar: :any,                 arm64_sonoma:   "93290582465ed3ba9fb67a8e9a609da68038bb657490a4735b8ddb75859f30ba"
    sha256 cellar: :any,                 arm64_ventura:  "97e8c8df5c36921224815910ccd8aa3fdce8f66f7b51ab2658404b16d026c659"
    sha256 cellar: :any,                 arm64_monterey: "930c20bd65468d75d7ad9c56573e19c11faf811e94300cde2aea8c14b77f7987"
    sha256 cellar: :any,                 sonoma:         "e0aff0b588c6e3366646183995697338c5802536b7974f454d6454dd4f050001"
    sha256 cellar: :any,                 ventura:        "85b9a8dcd0ad7e465c2dcdec26b62691bbd3be8458e7fcc87c4b0b46807c5d08"
    sha256 cellar: :any,                 monterey:       "ea2dc0465223cc6149eb74bf30ebe01874dacb484b40a2a74169bf629cdc8bc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "755428c13355b296d6bea89f02587b1252f29c05a73f1cdf2d88f71af73177d8"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"

  conflicts_with "snobol4", because: "both install `sdb` binaries"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"sdb", testpath/"d", "hello=world"
    assert_equal "world", shell_output("#{bin}/sdb #{testpath}/d hello").strip
  end
end
