class S6 < Formula
  desc "Small & secure supervision software suite."
  homepage "https://skarnet.org/software/s6/"

  stable do
    url "https://skarnet.org/software/s6/s6-2.4.0.0.tar.gz"
    sha256 "5e788d5935dbcce76ac9a99cfcf6ee46a2ffb84220c84225df7589e9a3585560"

    resource "skalibs" do
      url "https://skarnet.org/software/skalibs/skalibs-2.4.0.0.tar.gz"
      sha256 "a58cdcc8a2f083090632cdee01f962bee2f99c3f8be61f36c1e13adaef42cea9"
    end

    resource "execline" do
      url "https://skarnet.org/software/execline/execline-2.2.0.0.tar.gz"
      sha256 "93bd744f2e3ad204cb89f147efdc6ca4e622f9c6bfc9895e0b2cb8b0480029de"
    end
  end

  bottle do
    sha256 "d0de567c7b5a62e1d8c2ebdfb4805fcb298e4ed803aa04bbcf5b7df36c18b653" => :sierra
    sha256 "6380e7aa1495e3fce80bc9b07eab4abbb8d5ee5544faa8d2aa2d649139ff1988" => :el_capitan
    sha256 "d79a5fe7916358ba01046fcccad8523514e00805d04c134bd4ae7938d19b19ff" => :yosemite
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
