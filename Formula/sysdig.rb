class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://sysdig.com/"
  url "https://github.com/draios/sysdig/archive/0.26.7.tar.gz"
  sha256 "c82aa4201e8ad37e22c780c27c28ac28359a8e677b4dc0ea295eb1452115d6c0"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 "c3b1b55e16c9e7d143138c0b824872f000e92a9323c43683877da83c0eeeeda0" => :catalina
    sha256 "de3c1cedda2cdc14ba06892f556161c25f023975ff4a9b8a38ad47a13bcdc13d" => :mojave
    sha256 "41b0016def49ba75c9d48dcc4d017fe684aedb79e2a35132952cee85ec1c0b33" => :high_sierra
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
