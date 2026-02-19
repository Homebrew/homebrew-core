class Snobol4 < Formula
  desc "String oriented and symbolic programming language"
  homepage "https://www.regressive.org/snobol4/"
  url "https://ftp.regressive.org/snobol/snobol4-2.3.3.tar.gz"
  sha256 "bfd53071d69283776f5b2764f7865d354b89d372569854a18878e59f57388ed2"
  license "BSD-2-Clause"

  livecheck do
    url "https://ftp.regressive.org/snobol/"
    regex(/href=.*?snobol4[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "386f57258d19733bba9f79839743634ccdc0902fffe86afa9e0e8bf37b7fd035"
    sha256 arm64_sequoia: "be80dab2b55d9f5cdfe7048659aa67ed87b0e64819d2d8c213db3a897b7f8651"
    sha256 arm64_sonoma:  "8d6f1601dec1dd71250698920a2f3f51a4029da00408233459ce2dde4001fff5"
    sha256 sonoma:        "4afab736c1e01614e1d6d305fc65c9d17e2352cd50cb99473f0b8a573f428360"
    sha256 arm64_linux:   "5b19a3df62c11519f9fa0f4100fb82cfb9d97445f881f786de15764b3de37e60"
    sha256 x86_64_linux:  "04420e3ce73484c4ca3ee3115d30b9db317def98bf1ec831188385639f49d445"
  end

  depends_on "openssl@3"

  uses_from_macos "m4" => :build
  uses_from_macos "libffi"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "readline"
    depends_on "zlib-ng-compat"
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
