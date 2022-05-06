class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://github.com/radare/sdb"
  url "https://github.com/radareorg/sdb/archive/1.8.8.tar.gz"
  sha256 "646add20d2fcb4beb2d5a7910368ac7c8245a63fa243ab1d3bb3732fa3a2b148"
  license "MIT"
  head "https://github.com/radare/sdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "be36bdcd1618af66b970c9065c53f4fd8decc8b1444a2ba50c64de87baf2e000"
    sha256 cellar: :any,                 arm64_big_sur:  "f57086d47de992aed35787eb990c7e5cf9a678c45b61c004188156156623ce27"
    sha256 cellar: :any,                 monterey:       "b9fad697dbb950e3b7cf84fa876a4557e56bbb94eea3b9a952184073db3de54f"
    sha256 cellar: :any,                 big_sur:        "ce9d738ae013083d6993b255468964919b2b19c911c95a27a8c7eb13ed3eaa3a"
    sha256 cellar: :any,                 catalina:       "dd9e453d898cc2c456fb5cd5ee943aa5a843c83381fea81b542cba014cad6886"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcb88db1e47a0e12c96ecf7cb7486f20161e2a377c73e59118a2104dba943268"
  end

  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"sdb", testpath/"d", "hello=world"
    assert_equal "world", shell_output("#{bin}/sdb #{testpath}/d hello").strip
  end
end
