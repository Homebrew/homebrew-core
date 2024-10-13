class Snobol4 < Formula
  desc "String oriented and symbolic programming language"
  homepage "https://www.regressive.org/snobol4/"
  url "https://ftp.regressive.org/snobol/snobol4-2.3.2.tar.gz"
  sha256 "41e301e9dd180d70117d64f3694f9dd54f9ed909a36a32587c8bed85ab68ac15"
  license "BSD-2-Clause"

  livecheck do
    url "https://ftp.regressive.org/snobol/"
    regex(/href=.*?snobol4[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "a3ff59d306972bd935fdb85d54681c8ab597f3179b83b1b8ee216ef40582d732"
    sha256 arm64_sonoma:   "7baa9cfb9bdbb89ec8f1817fccc3f4a3531e56822617a3bab083459029a6457a"
    sha256 arm64_ventura:  "bab2633cd719743f5648b6a5fa32dae630ad6b7bc4400417747f834226c860e6"
    sha256 arm64_monterey: "90e3d3102cb1b10ad1578aad8f4fcaec31c2960a4ad54e54983f4778b5646a97"
    sha256 sonoma:         "c4576d539a10c904408404d64fde008b7939d8fbcddf2e739738b38c9fe613bd"
    sha256 ventura:        "c8c5b13e46532544bdc4fa93d3670fa5b648d5a9aa9593758a9e83bd9d72f897"
    sha256 monterey:       "e4d3d40f4b8bd51e49b1c99de9590e79f00876fadb28c13cf98070525106a5ea"
    sha256 x86_64_linux:   "c555c7e31212c27a251d42ebf6b166ee1ac59c6d306c60327a8e1e429d1a7f7a"
  end

  depends_on "openssl@3"

  uses_from_macos "m4" => :build
  uses_from_macos "libffi"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_linux do
    depends_on "readline"
  end

  conflicts_with "sdb", because: "both install `sdb` binaries"

  def install
    ENV.append_to_cflags "-I#{MacOS.sdk_path_if_needed}/usr/include/ffi" if OS.mac?
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    ENV.deparallelize
    # avoid running benchmark:
    system "make", "install_notiming"
  end

  test do
    # Verify modules build, test DBM.
    # NOTE! 1960's language! -include, comment, and labels (fail, end)
    # must all be in first column
    testfile = testpath/"test.sno"
    dbmfile = testpath/"test.dbm"
    (testpath/"test.sno").write <<~EOS
      -include 'digest.sno'
      -include 'dirs.sno'
      -include 'ezio.sno'
      -include 'ffi.sno'
      -include 'fork.sno'
      -include 'ndbm.sno'
      -include 'logic.sno'
      -include 'random.sno'
      -include 'sprintf.sno'
      -include 'sqlite3.sno'
      -include 'stat.sno'
      -include 'zlib.sno'
      * DBM test
              t = 'dbm'
              k = '🍺'
              v = '🙂'
              fn = '#{dbmfile}'
              h1 = dbm_open(fn, 'cw')         :f(fail)
              dbm_store(h1, k, v)             :f(fail)
              dbm_close(h1)                   :f(fail)
              h2 = dbm_open(fn, 'r')          :f(fail)
              v2 = dbm_fetch(h2, k)           :f(fail)
              ident(v, v2)                    :f(fail)
      * more tests here? (set t to test name before each test)
	      output = 'OK'
              :(end)
      fail    output = t ' test failed at ' &LASTLINE
              &code = 1
      end
    EOS
    assert_match "OK", shell_output("#{bin}/snobol4 #{testfile}")
  end
end
