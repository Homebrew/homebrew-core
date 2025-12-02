class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://www.radare.org/"
  url "https://github.com/radareorg/sdb/archive/refs/tags/2.2.4.tar.gz"
  sha256 "1af45fab8d6ba21dfe7bd57f4f37c8079441c1f0dd2222c003c922dbce37fa19"
  license "MIT"
  head "https://github.com/radareorg/sdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "32d079c91b88561509088a255419263c28670ae1b9f5004a5218e249b2e2029d"
    sha256 cellar: :any,                 arm64_sequoia: "6b2a1555776877111a2ad95f0f49a02aa259d3abff4afb9020a9023e1ad6057f"
    sha256 cellar: :any,                 arm64_sonoma:  "5d65aeabf7947d781b38effb17dbacf39de3b9fb6d30784335b0db4898b2c96e"
    sha256 cellar: :any,                 sonoma:        "840646e9e20b2678c775b3b8de281cf4ee505ec86136e6b4fc8de5b9480f8985"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61ecc7e6f21bd927033e505ca1feeb5bc88825833c28b73a648e48fe4690bc47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d02b0dc2773db9183b670df572950bab0760afe0391c305531be103194f681b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
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
