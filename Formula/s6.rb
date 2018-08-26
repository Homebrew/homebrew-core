class S6 < Formula
  desc "Small & secure supervision software suite"
  homepage "https://skarnet.org/software/s6/"

  stable do
    url "https://skarnet.org/software/s6/s6-2.7.2.0.tar.gz"
    sha256 "af54fcbae7028a90bd12c7ee71a8f3954a74c6a4de376a427cc664587fb68a09"

    resource "skalibs" do
      url "https://skarnet.org/software/skalibs/skalibs-2.7.0.0.tar.gz"
      sha256 "96494d76669d2f8622511d5d616b6367801a42683c0bb11a8855114e5ccbd756"
    end

    resource "execline" do
      url "https://skarnet.org/software/execline/execline-2.5.0.1.tar.gz"
      sha256 "8d07d14e9e9abb1301e08be271313c4ffa5ddf7248fd262dda19588e78e31049"
    end
  end

  bottle do
    sha256 "9f79c89212f365a311b5b15f1ccfaab68b65f82b49eaad02a5ea442e64f0f658" => :mojave
    sha256 "664060c1632fcbd35dc52d0f0bfad5367e5ea38f0c2562b876ff3c38bac37ca3" => :high_sierra
    sha256 "76e74a331066c5192a11d1aaabbdabf34d88d4c72f3fe44e372ea75a393be600" => :sierra
    sha256 "bceee1c191a4e8c36934c029ba59a661d52c42e2b09619a6d7e88ae143571d46" => :el_capitan
  end

  head do
    url "git://git.skarnet.org/s6"

    resource "skalibs" do
      url "git://git.skarnet.org/skalibs"
    end

    resource "execline" do
      url "git://git.skarnet.org/execline"
    end
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
