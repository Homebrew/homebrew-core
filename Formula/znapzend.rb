class Znapzend < Formula
  desc "zfs backup with remote capabilities and mbuffer integration"
  homepage "http://www.znapzend.org"
  url "https://github.com/oetiker/znapzend/releases/download/v0.15.5/znapzend-0.15.5.tar.gz"
  sha256 "f419f390de3b5da54f4d9aabd01027881f0572ead41a04b93d0f60dc28740343"

  bottle do
    cellar :any_skip_relocation
    sha256 "accb9bb472c3f07250357a44e2189e376ec15ef5bfa7d6171f80a0efdf7173bb" => :el_capitan
    sha256 "b69841286ab242e78ee23e71de2f3b3c340e1f1f6f078a1287433ae3d1510e75" => :yosemite
    sha256 "7d91e4f9ce37d5448140b97282ef57cd857616dbb0d1e68faa35797b98e52483" => :mavericks
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
