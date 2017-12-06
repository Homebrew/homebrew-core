class Shogun < Formula
  desc "Large scale machine learning toolbox"
  homepage "http://www.shogun-toolbox.org/"
  url "http://shogun-toolbox.org/archives/shogun/releases/6.1/sources/shogun-6.1.3.tar.bz2"
  sha256 "57169dc8c05b216771c567b2ee2988f14488dd13f7d191ebc9d0703bead4c9e6"

  bottle do
    sha256 "06aafb46d4cd4e53ebed6f8bb32e1279b5a8b5de9aae2359261cee9de87fc2ca" => :sierra
    sha256 "e5dd5b447ef40488fb32fa36e2eb943975a6b28db8ae27859e39cb8a87a077a9" => :el_capitan
    sha256 "b3d320d345da09b55ffb98a59f4fac3b2f6c2672fcbcda693fe0e7a9ee4795a3" => :yosemite
    sha256 "dfbd03cba5e1a134a520d6c06aceaa3c5143cad638fc208150d980a44e5252cf" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "arpack"
  depends_on "eigen"
  depends_on "glpk"
  depends_on "hdf5"
  depends_on :java
  depends_on "json-c"
  depends_on "lapack"
  depends_on "lzo"
  depends_on "nlopt"
  depends_on :python if MacOS.version <= :lion
  depends_on "readline"
  depends_on "snappy"
  depends_on "xz"

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/bf/2d/005e45738ab07a26e621c9c12dc97381f372e06678adf7dc3356a69b5960/numpy-1.13.3.zip"
    sha256 "36ee86d5adbabc4fa2643a073f93d5504bdfed37a149a3a49f4dde259f35a750"
  end

  resource "jblas" do
    url "https://mikiobraun.github.io/jblas/jars/jblas-1.2.3.jar"
    sha256 "e9328d4e96db6b839abf50d72f63626b2309f207f35d0858724a6635742b8398"
  end

  needs :cxx11

  def cmake_use(opt, arg)
    "-D#{arg}=#{build.with?(opt) ? "ON" : "OFF"}"
  end

  def install
    ENV.cxx11
    # fix build of modular interfaces with SWIG 3.0.5 on MacOSX
    # https://github.com/shogun-toolbox/shogun/pull/2694
    # https://github.com/shogun-toolbox/shogun/commit/fef8937d215db7
    ENV.append_to_cflags "-D__ASSERT_MACROS_DEFINE_VERSIONS_WITHOUT_UNDERSCORES=0"

    ENV["PYTHONPATH"] = libexec/"lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    res = %w[numpy]
    res.each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    env = {
      :PATH => "#{libexec}/vendor/bin:$PATH",
      :PYTHONPATH => ENV["PYTHONPATH"],
      :LAPACKE_PATH => '#{Formula["lapack"].opt_lib}',
    }
    bin.env_script_all_files(libexec/"bin", env)

    libexec.install resource("jblas")

    args = std_cmake_args + [
      "-DBUILD_EXAMPLES=OFF",
      "-DBUNDLE_JSON=OFF",
      "-DBUNDLE_NLOPT=OFF",
      "-DENABLE_TESTING=OFF",
      "-DENABLE_COVERAGE=OFF",
      "-DBUILD_META_EXAMPLES=OFF",
      "-DINTERFACE_PYTHON=ON",
      "-DINTERFACE_JAVA=ON",
      "-DLIB_INSTALL_DIR=#{lib}",
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS
        #include <cstdlib>
        #include <cstring>
        #include <assert.h>

        #include <shogun/base/init.h>
        #include <shogun/lib/versionstring.h>

        using namespace shogun;

        int main(int argc, char** argv)
        {
          init_shogun_with_defaults();
          assert (std::strcmp(MAINVERSION, "6.1.3") == 0);
          exit_shogun();

          return EXIT_SUCCESS;
        }
      EOS

    ENV.cxx11
    cxx_with_flags = ENV.cxx.split + ["-I#{include}", "test.cpp",
                                      "-o", "test", "-L#{lib}", "-lshogun"]
    system *cxx_with_flags
    system "./test"
  end
end
