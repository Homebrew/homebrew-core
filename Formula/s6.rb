class S6 < Formula
  desc "Small & secure supervision software suite"
  homepage "https://skarnet.org/software/s6/"
  url "https://skarnet.org/software/s6/s6-2.11.1.0.tar.gz"
  sha256 "ae64dc2ba208ff80e4ac4792ce90dd526b42bf19c966dc7d8eb9a6870e4bc23a"
  license "ISC"

  livecheck do
    url :homepage
    regex(/href=.*?s6[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "fc6992abd243bb3382d7543ca0fd2e2f1d7e2a9a897dedeefb9a8f1471c84c35"
    sha256 arm64_big_sur:  "2c1eab12eb707f3e180ce63acc9ac5dda966924fc6a96938260e4b7ce4967c61"
    sha256 monterey:       "d661bf4caa7053680dd26c082de3638df7150d8e1a1310e00939e1ce5d3b8638"
    sha256 big_sur:        "460dc845a4859dc58509537f2f947258539a95b6ca38c5277de65bc9dccf5ace"
    sha256 catalina:       "1127e18d4aa4fe14e9a14a42a518fbfadece1f308b7a84c6ac8736701799ebd6"
    sha256 x86_64_linux:   "ff653d66b5f2af2877ac487014b6406bbe8ee56eda69547d6ffbf6b7f5fe3f08"
  end

  resource "skalibs" do
    url "https://skarnet.org/software/skalibs/skalibs-2.11.2.0.tar.gz"
    sha256 "649cf3236fe3103f45366b6196b1bcd0457c9c17ca86f2b80007696a2baa7b77"
  end

  resource "execline" do
    url "https://skarnet.org/software/execline/execline-2.8.3.0.tar.gz"
    sha256 "235dbecd594c82e0523c87c2eacf04c48781b39264158f57049f1a1ff8b4ad80"
  end

  def install
    resources.each { |r| r.stage(buildpath/r.name) }
    build_dir = buildpath/"build"

    cd "skalibs" do
      system "./configure", "--disable-shared", "--prefix=#{build_dir}", "--libdir=#{build_dir}/lib"
      system "make", "install"
    end

    cd "execline" do
      system "./configure",
        "--prefix=#{build_dir}",
        "--bindir=#{libexec}/execline",
        "--with-include=#{build_dir}/include",
        "--with-lib=#{build_dir}/lib",
        "--with-sysdeps=#{build_dir}/lib/skalibs/sysdeps",
        "--disable-shared"
      system "make", "install"
    end

    system "./configure",
      "--prefix=#{prefix}",
      "--libdir=#{build_dir}/lib",
      "--includedir=#{build_dir}/include",
      "--with-include=#{build_dir}/include",
      "--with-lib=#{build_dir}/lib",
      "--with-lib=#{build_dir}/lib/execline",
      "--with-sysdeps=#{build_dir}/lib/skalibs/sysdeps",
      "--disable-static",
      "--disable-shared"
    system "make", "install"

    # Some S6 tools expect execline binaries to be on the path
    bin.env_script_all_files(libexec/"bin", PATH: "#{libexec}/execline:$PATH")
    sbin.env_script_all_files(libexec/"sbin", PATH: "#{libexec}/execline:$PATH")
    (bin/"execlineb").write_env_script libexec/"execline/execlineb", PATH: "#{libexec}/execline:$PATH"
    doc.install Dir["doc/*"]
  end

  test do
    (testpath/"test.eb").write <<~EOS
      foreground
      {
        sleep 1
      }
      "echo"
      "Homebrew"
    EOS
    assert_match "Homebrew", shell_output("#{bin}/execlineb test.eb")

    (testpath/"log").mkpath
    pipe_output("#{bin}/s6-log #{testpath}/log", "Test input\n", 0)
    assert_equal "Test input\n", File.read(testpath/"log/current")
  end
end
