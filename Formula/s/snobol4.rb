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
    sha256 arm64_tahoe:   "76b3222469613ba6e90653854907660b1b13724b1a2920efe6893cbfb1f7e968"
    sha256 arm64_sequoia: "d628d4ea0897d407f1b244dc75fb8168b93d77b1de0c862200acfba011096009"
    sha256 arm64_sonoma:  "b3f7a50e01ebddadfe570f4e13a630898a86e388e65ac4e2cad8e88b268b3d1e"
    sha256 arm64_ventura: "a382d391551c2bf3462b47c2214c0d4bd7f79fbc90b46494a6bfa13fc60ea825"
    sha256 sonoma:        "b6eb99a66c91dee6b0de92822663111e954207148a3ff26f7e5c7460d17ddc09"
    sha256 ventura:       "677075a50ad434850c41aa511e5382a8306acc3ad8a65a386e5105463f96fff7"
    sha256 arm64_linux:   "94b2fcd9d8c0e566448129cd582b82bbe03bab0f1c2e3e15fa60e6c6540739a9"
    sha256 x86_64_linux:  "0cf89fdce929dfabbed1e366a5d85e7206adc6b520bbecec8950259b505b1c04"
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
