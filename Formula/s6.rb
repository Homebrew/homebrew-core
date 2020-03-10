class S6 < Formula
  desc "Small & secure supervision software suite"
  homepage "https://skarnet.org/software/s6/"
  url "https://skarnet.org/software/s6/s6-2.9.1.0.tar.gz"
  sha256 "05e259532c6db8cb23f5f79938669cee30152008ac9e792ff4acb26db9a01ff7"

  bottle do
    sha256 "f9b95da1b5dde761446263f5abfc9d278c87fa6f7ad83f809503cc82bdeaa691" => :catalina
    sha256 "46cb227d5bcfb4e9c17174a76e7138bd896dda52912c6dbf744f7aa40c388ed9" => :mojave
    sha256 "88345eff5034e9f7b21943b6c6db34204acce6421b85f4ac598d503550f60960" => :high_sierra
  end

  resource "skalibs" do
    url "https://skarnet.org/software/skalibs/skalibs-2.9.2.0.tar.gz"
    sha256 "e4c36e91ddb8f94f7bb61479bb3a5fbdaa423772ba7583151a03ce30003f2dc5"
  end

  resource "execline" do
    url "https://skarnet.org/software/execline/execline-2.6.0.0.tar.gz"
    sha256 "5415f5b98c8e3edb8e94fa9c9d42de1cdb86a8977e9b4212c9122bdcb9dad7d4"
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
    bin.env_script_all_files(libexec/"bin", :PATH => "#{libexec}/execline:$PATH")
    sbin.env_script_all_files(libexec/"sbin", :PATH => "#{libexec}/execline:$PATH")
    (bin/"execlineb").write_env_script libexec/"execline/execlineb", :PATH => "#{libexec}/execline:$PATH"
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
