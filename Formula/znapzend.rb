class Znapzend < Formula
  desc "ZFS backup with remote capabilities and mbuffer integration"
  homepage "https://www.znapzend.org/"
  url "https://github.com/oetiker/znapzend/releases/download/v0.19.0/znapzend-0.19.0.tar.gz"
  sha256 "fc5c3d6f03daf6ac03b079434f84b1918b777faba54393d7089e14f0b9d27acd"
  head "https://github.com/oetiker/znapzend.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0c7244aee12a58f2f77649685678d1623cd6610be600a72903a039760e2031f" => :high_sierra
    sha256 "5806e406955b12e066fd5c26c245d3fdbf2a7a70b96d90bd3a06280a28b2fce1" => :sierra
    sha256 "77e2e0b4b43eeb71e41fa7d99f8ff25a4b54cb2321714a3bd85a651f4373621a" => :el_capitan
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
