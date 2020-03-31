class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://sysdig.com/"
  url "https://github.com/draios/sysdig/archive/0.26.6.tar.gz"
  sha256 "d215d9b5835db6eec0dc6f0bac96552fd8bd7c71d3d6ed482423cdddd5b1c93e"

  bottle do
    sha256 "c285e8f4af3d440cff0620e722c564e2750cc0bfd067307a18ecbcf825c9e985" => :catalina
    sha256 "372b37adc0d683f085f18b409a24cb3aabc0776aaebeacb164530f77e9d06393" => :mojave
    sha256 "ce2acdf4dcf9d540fccee7390306723c8517f0fcee9440a01cb9f22bd392751e" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "jsoncpp"
  depends_on "luajit"
  depends_on "tbb"

  # More info on https://gist.github.com/juniorz/9986999
  resource "sample_file" do
    url "https://gist.githubusercontent.com/juniorz/9986999/raw/a3556d7e93fa890a157a33f4233efaf8f5e01a6f/sample.scap"
    sha256 "efe287e651a3deea5e87418d39e0fe1e9dc55c6886af4e952468cd64182ee7ef"
  end

  def install
    mkdir "build" do
      system "cmake", "..", "-DSYSDIG_VERSION=#{version}",
                            "-DUSE_BUNDLED_DEPS=OFF",
                            "-DCREATE_TEST_TARGETS=OFF",
                            *std_cmake_args
      system "make"
      system "make", "install"
    end

    (pkgshare/"demos").install resource("sample_file").files("sample.scap")
  end

  test do
    output = shell_output("#{bin}/sysdig -r #{pkgshare}/demos/sample.scap")
    assert_match "/tmp/sysdig/sample", output
  end
end
