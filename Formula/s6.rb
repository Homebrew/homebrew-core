class S6 < Formula
  desc "Small & secure supervision software suite"
  homepage "https://skarnet.org/software/s6/"
  url "https://skarnet.org/software/s6/s6-2.8.0.1.tar.gz"
  sha256 "dbe08f5b76c15fa32a090779b88fb2de9a9a107c3ac8ce488931dd39aa1c31d8"

  bottle do
    sha256 "4c1819aca5030161f69a0e8ff7a1c70ca7056e0226b173e3c7098709c2fb03a9" => :mojave
    sha256 "8600da62dfe7099ba8526addf7dda2a09d9eeb63e7cbe6e5602b1944967b5ea3" => :high_sierra
    sha256 "a72070b37a6b2d9ae738f32e7970e748c9d354b921718c2ea8d27b6cc5bdb0fc" => :sierra
  end

  resource "skalibs" do
    url "https://skarnet.org/software/skalibs/skalibs-2.8.1.0.tar.gz"
    sha256 "431c6507b4a0f539b6463b4381b9b9153c86ad75fa3c6bfc9dc4722f00b166ba"
  end

  resource "execline" do
    url "https://skarnet.org/software/execline/execline-2.5.1.0.tar.gz"
    sha256 "b1a756842947488404db8173bbae179d6e78b6ef551ec683acca540ecaf22677"
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
