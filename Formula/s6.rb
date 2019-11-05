class S6 < Formula
  desc "Small & secure supervision software suite"
  homepage "https://skarnet.org/software/s6/"
  url "https://skarnet.org/software/s6/s6-2.9.0.1.tar.gz"
  sha256 "e0cdbaf26e3ba1c41ecc0a8d1f45fb78194f96109b55cabeb849528b7e966c57"

  bottle do
    sha256 "e10f7001d61d1e9effd0c5bceef485301ce37fcf7efb84b77297621df70d31d7" => :catalina
    sha256 "4c1819aca5030161f69a0e8ff7a1c70ca7056e0226b173e3c7098709c2fb03a9" => :mojave
    sha256 "8600da62dfe7099ba8526addf7dda2a09d9eeb63e7cbe6e5602b1944967b5ea3" => :high_sierra
    sha256 "a72070b37a6b2d9ae738f32e7970e748c9d354b921718c2ea8d27b6cc5bdb0fc" => :sierra
  end

  resource "skalibs" do
    url "https://skarnet.org/software/skalibs/skalibs-2.9.1.0.tar.gz"
    sha256 "d3b204afc462b9659e0c16f6df1c796e7612534f537eec053529f67ddcd086a5"
  end

  resource "execline" do
    url "https://skarnet.org/software/execline/execline-2.5.3.0.tar.gz"
    sha256 "05205c6869ae65a51c63d0e805572573806f6474aa21e12c49dd5654d3ceed33"
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
