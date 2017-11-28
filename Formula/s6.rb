class S6 < Formula
  desc "Small & secure supervision software suite"
  homepage "https://skarnet.org/software/s6/"

  stable do
    url "https://skarnet.org/software/s6/s6-2.6.2.0.tar.gz"
    sha256 "0313e4b55c11a3e12d2e9766971c9cc1eb0aef85ddbb5a4385923839e937acb0"

    resource "skalibs" do
      url "https://skarnet.org/software/skalibs/skalibs-2.6.2.0.tar.gz"
      sha256 "12f9706b412367c45310ab971d204d959441895d3fea6e5e41ab8ef8d24b71b2"
    end

    resource "execline" do
      url "https://skarnet.org/software/execline/execline-2.3.0.4.tar.gz"
      sha256 "e4bb8fc8f20cca96f4bac9f0f74ebce5081b4b687bb11c79c843faf12507a64b"
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
