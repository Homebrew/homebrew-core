class S6 < Formula
  desc "Small & secure supervision software suite."
  homepage "https://skarnet.org/software/s6/"

  stable do
    url "https://skarnet.org/software/s6/s6-2.6.1.1.tar.gz"
    sha256 "0172b7293d4d5607ca3ca77382fee9b87c10bd58680720b29625cf35afc75c5c"

    resource "skalibs" do
      url "https://skarnet.org/software/skalibs/skalibs-2.6.0.1.tar.gz"
      sha256 "b11f515d29768497d648c7ae87e26f7441395a056ebbe3fe89596fe6454a557a"
    end

    resource "execline" do
      url "https://skarnet.org/software/execline/execline-2.3.0.3.tar.gz"
      sha256 "1a698425740a410a38be770f98b8faf94c633e29a74ba1d25adddbb294e979f5"
    end
  end

  bottle do
    sha256 "7e71ba04eda076b77ba31f45ac541be99cbdc3b77d3d709e2e2b0ddaead64196" => :high_sierra
    sha256 "b310708d3412090fc959c0517882804b5b17c9f9500b3f6d4aca8c3fc180c4bd" => :sierra
    sha256 "c9c42a57a5c90ab67a52a295e7643e854c3696a7cc4eac122ebe25490815bf2b" => :el_capitan
    sha256 "4a5760024698c19b23460ac840d166936e3e61bd30d71e28019d35a99d5ac017" => :yosemite
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
    test_script.write <<-EOS.undent
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
