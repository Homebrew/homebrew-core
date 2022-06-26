class Snobol4 < Formula
  desc "String oriented and symbolic programming language"
  homepage "https://www.regressive.org/snobol4/"
  url "https://ftp.regressive.org/snobol/snobol4-2.3.1.tar.gz"
  sha256 "91244d67d4e29d2aadce5655bd4382ffab44c624a7ea4ad6411427f3abf17535"
  license "BSD-2-Clause"

  bottle do
    sha256 arm64_monterey: "fe4801587f606425a334e82ab263dc0ecdee0fbf62b1f7143833ad5adb252741"
    sha256 arm64_big_sur:  "b27844933479e0ed826723773ec52432f91321a47bd50c5c317745daf5929d26"
    sha256 monterey:       "8fe0d3f23e9016e42e81b0587b7a0e8bbf8702f05593c9bfad5d2c2477ac1fd9"
    sha256 big_sur:        "f1f8bb7965f2986825c5cb6748eaf968c9bddf4d4abbb611143e149bb5e0fcc8"
    sha256 catalina:       "b062904758f62326d952e01b9e5c1dadb973104d75a1064b18eaf1fa01b06799"
    sha256 x86_64_linux:   "331ea256a30ddb70976b0896b4c62eac113fb905550f8420d03f9e065eea5db8"
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
