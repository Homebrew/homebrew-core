class Znapzend < Formula
  desc "ZFS backup with remote capabilities and mbuffer integration"
  homepage "https://www.znapzend.org/"
  url "https://github.com/oetiker/znapzend/releases/download/v0.18.0/znapzend-0.18.0.tar.gz"
  sha256 "7ef999106a6dd7120787f87ed6a2775b32b2c84af6284d573a71e2a5a4c63296"
  head "https://github.com/oetiker/znapzend.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c45731738fb108265f45b306fddbe092abd87cc3142cd0865da0232e0fc5f66f" => :high_sierra
    sha256 "eb53a6be8ea72b0a38ad708117680607438f5a6be8bfbd343372c2504fed6c3f" => :sierra
    sha256 "f9dfe88cd397e098035ef459ca50f3221f94438eb60cd0f39fe146958bc930f9" => :el_capitan
    sha256 "0e39422d2f6fd57fd26a23b137e98f09fcb97b43c0d9d980b0fda26012e469e3" => :yosemite
  end

  depends_on "perl" if MacOS.version <= :mavericks

  def install
    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    fake_zfs = testpath/"zfs"
    fake_zfs.write <<~EOS
      #!/bin/sh
      for word in "$@"; do echo $word; done >> znapzendzetup_said.txt
      exit 0
    EOS
    chmod 0755, fake_zfs
    ENV.prepend_path "PATH", testpath
    system "#{bin}/znapzendzetup", "list"
    assert_equal <<~EOS, (testpath/"znapzendzetup_said.txt").read
      list
      -H
      -o
      name
      -t
      filesystem,volume
    EOS
  end
end
