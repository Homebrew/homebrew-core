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
    sha256 arm64_monterey: "430018a7e631e3373c62d088d97447a386c6e9195d921762d7fe4623b28703a8"
    sha256 arm64_big_sur:  "487d985735ece4d0c20c23da9297beaf31f4a8eb9360ff2de5661d47827e3b38"
    sha256 monterey:       "ffaedb5a289f67ee46e4271cbd4bfad2324b886aebd809ab697f11927820be8e"
    sha256 big_sur:        "fcfe44b724eca0296a943a0144e2b255dc136acf453609cd3b750c2dec096157"
    sha256 catalina:       "7c142969164daf7de6dff70845eb2f108818bb0b610ae702a769c61d168d67e5"
    sha256 x86_64_linux:   "5af126d12b8f8cb16e8da8b936e912fd1f4f7a65642743eaa0c26de84278e573"
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
