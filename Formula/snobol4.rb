class Snobol4 < Formula
  desc "String oriented and symbolic programming language"
  homepage "https://www.regressive.org/snobol4/"
  url "https://ftp.regressive.org/snobol/snobol4-2.3.1.tar.gz"
  sha256 "91244d67d4e29d2aadce5655bd4382ffab44c624a7ea4ad6411427f3abf17535"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "505e0a672763a6722cdac5f45129c79172a17b62cc2ca8e16166c00e39ae28e6"
    sha256 arm64_monterey: "a53dcbc020bfb1f4717e77b9b329fedef3be50f57fa30bb2c55cde9a124eb9bd"
    sha256 arm64_big_sur:  "4ed47b83e9a1e747c178a7b1ebb17d1c752c8f354d91f8e03f4c31e7a9b7f6ed"
    sha256 ventura:        "415f81ff2821f8e0f7a6f29b4e2c8ed1aad6a32c8be79ac2e5d9e26cb22d9146"
    sha256 monterey:       "9273da745ee760883553c560010c999831afcadbf1cf220188f260cb7a2269d3"
    sha256 big_sur:        "ac601704cde8de8f0334349e32f82cd2a9ce6cd5467d995fe8ac1ea79747c42b"
    sha256 catalina:       "1196997d82a94df4c3ec3438f02d3a32360f809a2d66af7205a6ee9959ede4b6"
    sha256 x86_64_linux:   "bc243751bbaf442dea44e1e571ab0d8ca129e91615a45be6024b275e085191ad"
  end

  depends_on "openssl@3"

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
