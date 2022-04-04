class Snobol4 < Formula
  desc "String oriented and symbolic programming language"
  homepage "https://www.regressive.org/snobol4/"
  url "https://ftp.regressive.org/snobol/snobol4-2.3.1.tar.gz"
  sha256 "91244d67d4e29d2aadce5655bd4382ffab44c624a7ea4ad6411427f3abf17535"
  license "BSD-2-Clause"

  bottle do
    sha256 arm64_monterey: "299aeba49fe6d16891bdc2cc21bbd67f8d1b621c981709220c281e9951d0a276"
    sha256 arm64_big_sur:  "deab0b471d4e29f0bd4eefd010b479190d2e940b2f962bc12080c32e1cdf1aaf"
    sha256 monterey:       "21d5ffad54fd230849ea3cea7b484555a7e0f12bc7b505384a78d676534f0555"
    sha256 big_sur:        "14172b3d9e48c6b7401c5fa84c3169fef2fcb72ed023ce87779950b7cc8210cf"
    sha256 catalina:       "d1902c73b221c4ed0e97c6a9da03d154dbaf81e18b8420ff2e4bbd320c349644"
    sha256 mojave:         "836e69e4b55f8e061d3862b0f52b7c9800a224e4186bb2116f5d2121b4ed4f79"
    sha256 high_sierra:    "9282b4f4887f0e031321314fcb4ed9af82b7f023c2c20f8cf7b7d278c098424b"
    sha256 sierra:         "2c8d1b2a54a3a3f0d810c88bc0a2545dbea08f73b57dda6052c4de27bdde62ee"
    sha256 el_capitan:     "f4ee5ba3a933998e7ea1493bab469f00f4ddd13a3e8458002ee43ba6f0cd0e74"
    sha256 yosemite:       "6903e1b05a795eae13f2f97fd2f1f4b883b03e1c94ba28e3747b3df98c6a955d"
  end

  depends_on "openssl@1.1"

  uses_from_macos "m4" => :build
  uses_from_macos "libffi"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_linux do
    depends_on "readline"
  end

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
