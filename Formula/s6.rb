class S6 < Formula
  desc "Small & secure supervision software suite"
  homepage "https://skarnet.org/software/s6/"
  url "https://skarnet.org/software/s6/s6-2.11.1.2.tar.gz"
  sha256 "6c1474be3e889dac392cee307abe015cd4be0c85c725c84ea7f184f0e34503a2"
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
    url "https://skarnet.org/software/skalibs/skalibs-2.12.0.1.tar.gz"
    sha256 "3e228f72f18d88c17f6c4e0a66881d6d3779427b7e7e889f3142b6f26da30285"
  end

  resource "execline" do
    url "https://skarnet.org/software/execline/execline-2.9.0.1.tar.gz"
    sha256 "01260fcaf80ffbca2a94aa55ea474dfb9e39b3033b55c8af88126791879531f6"
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
