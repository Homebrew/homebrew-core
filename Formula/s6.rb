class S6 < Formula
  desc "Small & secure supervision software suite"
  homepage "https://skarnet.org/software/s6/"
  url "https://skarnet.org/software/s6/s6-2.11.1.1.tar.gz"
  sha256 "1cef7f7b3a7e01181fbb6fe8300e6ba422d9689007221c78af1f99528acb6c38"
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
    url "https://skarnet.org/software/skalibs/skalibs-2.12.0.0.tar.gz"
    sha256 "e6d724b4c628f093df75c98f1274d8bd6c0ecdb09cc6816d3268bacb58647f30"
  end

  resource "execline" do
    url "https://skarnet.org/software/execline/execline-2.9.0.0.tar.gz"
    sha256 "d4906aad8c3671265cfdad1aef265228bda07e09abd7208b4f093ac76f615041"
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
