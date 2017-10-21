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
    sha256 "78248e3e2f69a44f4ebaa1623461d8419ea0c43de77281c5ac9937b1805d7555" => :high_sierra
    sha256 "ee608b2efe9a0115734a9ef93557b5b154b61b5c92af84e09594f93c9ce5c109" => :sierra
    sha256 "735449f95a1b7ad5812a456bb0916ad19527133cca0c6573df2372796b906a4c" => :el_capitan
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
