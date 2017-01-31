class Znapzend < Formula
  desc "zfs backup with remote capabilities and mbuffer integration"
  homepage "http://www.znapzend.org"
  url "https://github.com/oetiker/znapzend/releases/download/v0.16.0/znapzend-0.16.0.tar.gz"
  sha256 "caffe6022110e22096dc4f30f2da833cf72e6c9ed3fc4ead189f6d3039c84f1c"

  bottle do
    cellar :any_skip_relocation
    sha256 "0335ef972b970c8564dde34931e237c269926fa40dc249535ad81e0cac27a68e" => :sierra
    sha256 "f2bac52a01bb2b1d316731dd07e3724914ff56633343fe38c365447dc0b0632a" => :el_capitan
    sha256 "69545c77042d1330feae74f62357d7d4ec5a693c5d6911998bd97ec0ed1932e7" => :yosemite
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
