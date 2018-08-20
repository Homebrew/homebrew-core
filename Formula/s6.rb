class S6 < Formula
  desc "Small & secure supervision software suite"
  homepage "https://skarnet.org/software/s6/"

  stable do
    url "https://skarnet.org/software/s6/s6-2.7.1.1.tar.gz"
    sha256 "f37547f2890eb50bcb4cd46ffa38bad5ec9e6fd6bc7b73a8df0bdf0cf11f01a9"

    resource "skalibs" do
      url "https://skarnet.org/software/skalibs/skalibs-2.6.4.0.tar.gz"
      sha256 "30ac73f1e8da6387fcfa19cfe1e326a143b4d811aaf532988b280daefa56dcc7"
    end

    resource "execline" do
      url "https://skarnet.org/software/execline/execline-2.3.0.4.tar.gz"
      sha256 "e4bb8fc8f20cca96f4bac9f0f74ebce5081b4b687bb11c79c843faf12507a64b"
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
    # Test execline
    test_script = testpath/"test.eb"
    test_script.write <<~EOS
      import PATH
      if { [ ! -z ${PATH} ] }
        true
    EOS
    system "#{bin}/execlineb", test_script

    # Test s6
    (testpath/"log").mkpath
    pipe_output("#{bin}/s6-log #{testpath}/log", "Test input\n")
    assert_equal "Test input\n", File.read(testpath/"log/current")
  end
end
