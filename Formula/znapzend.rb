class Znapzend < Formula
  desc "ZFS backup with remote capabilities and mbuffer integration"
  homepage "https://www.znapzend.org/"
  url "https://github.com/oetiker/znapzend/releases/download/v0.19.1/znapzend-0.19.1.tar.gz"
  sha256 "93e3ec3c6f5cdf6973f72a6b764c49dc6545f2a0a2e0267a1382d471b930efea"
  head "https://github.com/oetiker/znapzend.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7fca9b0f4b129afbc30bee164b1a73911e4da9e48c4943b1d6e7e8e77a1cec17" => :high_sierra
    sha256 "f12ede845017559f77147ceab275fcbb128f3bdec7a1ff0cd72d54029349a419" => :sierra
    sha256 "d88080d21fd9def227853fc0d08db6bef5a10d0bca74c16c0207f023aabc8d67" => :el_capitan
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
