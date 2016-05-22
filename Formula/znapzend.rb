class Znapzend < Formula
  desc "zfs backup with remote capabilities and mbuffer integration"
  homepage "http://www.znapzend.org"
  url "https://github.com/oetiker/znapzend/releases/download/v0.15.7/znapzend-0.15.7.tar.gz"
  sha256 "7d2cf9955e058f42a58c19e1cd4c36a972fb4a303a2eba8b23651117e5ec812e"

  bottle do
    cellar :any_skip_relocation
    sha256 "7f22ee659925d6b5d1667cd2cceef518b88bc443a33a4e38471535433fb8d87f" => :el_capitan
    sha256 "ee6f5a2dbfd00ab21472dc27f430febe0ebb5d218d42597c96336ef9ea8bd749" => :yosemite
    sha256 "6eb5d715fc5d7c3d3bd929d08f6dc3961182611f10e211961e540d17a7f31cde" => :mavericks
  end

  depends_on "perl" if MacOS.version <= :mavericks

  def install
    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    fake_zfs = testpath/"zfs"
    fake_zfs.write <<-EOS.undent
      #!/bin/sh
      for word in "$@"; do echo $word; done >> znapzendzetup_said.txt
      exit 0
    EOS
    chmod 0755, fake_zfs
    ENV.prepend_path "PATH", testpath
    system "#{bin}/znapzendzetup", "list"
    assert_equal <<-EOS.undent, (testpath/"znapzendzetup_said.txt").read
      list
      -H
      -o
      name
      -t
      filesystem,volume
    EOS
  end
end
