class Znapzend < Formula
  desc "zfs backup with remote capabilities and mbuffer integration"
  homepage "http://www.znapzend.org"
  url "https://github.com/oetiker/znapzend/releases/download/v0.15.7/znapzend-0.15.7.tar.gz"
  sha256 "7d2cf9955e058f42a58c19e1cd4c36a972fb4a303a2eba8b23651117e5ec812e"

  bottle do
    cellar :any_skip_relocation
    sha256 "271f667915b018da03fe5bf248c2898f8a3f474a3978482685c64bd88d5c5f51" => :sierra
    sha256 "b6d641f12a56d7a911128b42d51487697f7483efca63e2093290d21a131a309e" => :el_capitan
    sha256 "a2b0ddd2b42e9c436b7cc7d98db98798cddcda70b3f8484f70c94bc11f4b6209" => :yosemite
    sha256 "6b44f5c900f903f23349a564cfd8fc6f4b588dba162c3626c9bbc1d4c151ae31" => :mavericks
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
