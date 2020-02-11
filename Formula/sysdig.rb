class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://sysdig.com/"
  url "https://github.com/draios/sysdig/archive/0.26.5.tar.gz"
  sha256 "3a251eca408e71df9582eac93632d8927c5abcc8d09b25aa32ef6d9c99a07bd4"

  bottle do
    rebuild 1
    sha256 "45af3ff3c080f5cbc94d5c018064b5e8e211bf66e95fb819b90810391d82c7be" => :catalina
    sha256 "a8a752b94739d3a67b7fe2261f133fd5ad11921090c5e09b6b2954f68cf60a29" => :mojave
    sha256 "280f3c0cb293d38549ef40d87a2d7e9c37ca2b08dfb65aad9ac3b52da84fd28a" => :high_sierra
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
