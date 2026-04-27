class Snobol4 < Formula
  desc "String oriented and symbolic programming language"
  homepage "https://www.regressive.org/snobol4/"
  url "https://ftp.regressive.org/snobol/snobol4-2.3.4.tar.gz"
  sha256 "702f73b4107438bd251ebc253d335994f37bb40379242360d876e2de6dc03f78"
  license "BSD-2-Clause"

  livecheck do
    url "https://ftp.regressive.org/snobol/"
    regex(/href=.*?snobol4[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "d4705fd2288b5ccba0db75e7591f830fc8bc2babe97ecdf69a02f6f63d40ba61"
    sha256 arm64_sequoia: "4007a100e7b4d9b64f9db697af1945e112328147e5e8266d04cd886eac8ae244"
    sha256 arm64_sonoma:  "894a4a4941fdd854b231a3d5ffb204d939f4c5b1762839bcbd81ceb8051a3a82"
    sha256 sonoma:        "4eba9e8ee63ac75e239471017f83795c37b762d9e7c657172643179d611f19c4"
    sha256 arm64_linux:   "92192ac1c1040101f2f7725f49bdd4e48ca77f33c9b947378db747e0308ea13f"
    sha256 x86_64_linux:  "bae8485b664f3c999e1eee9ec0c87cae6283e414b2606fb172b516284176311f"
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
