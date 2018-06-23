class Znapzend < Formula
  desc "ZFS backup with remote capabilities and mbuffer integration"
  homepage "https://www.znapzend.org/"
  url "https://github.com/oetiker/znapzend/releases/download/v0.19.0/znapzend-0.19.0.tar.gz"
  sha256 "fc5c3d6f03daf6ac03b079434f84b1918b777faba54393d7089e14f0b9d27acd"
  head "https://github.com/oetiker/znapzend.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c831a9da2c041639003cda93d5d8ca9270115806af14805be19b760cd654d8c1" => :high_sierra
    sha256 "5a43e9538489018088338386ca07fcce56208df63a89ca634d087a2fa2ad502a" => :sierra
    sha256 "3121abf2d721ca269094feb9a9b36febafb0f550b82a56ae04a5fc50b6aedbec" => :el_capitan
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
